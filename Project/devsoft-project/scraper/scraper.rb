# encoding:utf-8

require 'mechanize'

################################################
##           !USE YOUR CREDENTIALS            ##
################################################
USERNAME = 'aluno' # Use your username!
PASSWORD = '12345' # Use your password!

#
# Helper function that saves a HTML file on the html directory.
#
# @param [String] filename the name of the file to be saved.
# @param [String] body the body of the HTML file.
#

#Checks if the object 'a' has a duplicate in the collection.
  #Returns the key (or id) if there is a match
def hasDuplicate (a, collection)

  collection.each do |key, i| 

    if isDuplicate(a,i)

      return key
      
    end

  end

  return false

end

#Checks if the objects a and b are duplicates.
def isDuplicate (a, b) 

  a.keys.each do |i| 

    #Check if the same class
    if a[i].class and b[i].class

      #Check if string
      if a[i].respond_to?("casecmp")
        
        if a[i].casecmp(b[i]) != 0

          return false

        end

      #If not, use simple comparison
      elsif a[i] != b[i]

        return false

      end
      
    else

      return false

    end

  end

  return true

end

def save_html(filename, body)
  File.open("saved_html/#{filename}.html", "w") do |f|
    f.write(body.force_encoding('utf-8'))
  end
end

mechanize = Mechanize.new
mechanize.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36"

mechanize.get('http://estagios.pcs.usp.br/')
mechanize.get('http://estagios.pcs.usp.br/semLogin/login.aspx')

save_html('before_login', mechanize.page.body)

form = mechanize.page.forms[0]

headers = {
  'Host' => 'estagios.pcs.usp.br',
  'Connection'      => 'keep-alive',
  'Cache-Control'   => 'max-age=0',
  'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
  'Origin'          => 'http://estagios.pcs.usp.br',
  'Content-Type'    => 'application/x-www-form-urlencoded',
  'Referer'         => 'http://estagios.pcs.usp.br/semLogin/login.aspx',
  'Accept-Encoding' => 'gzip,deflate,sdch',
  'Accept-Language' => 'en-US,en;q=0.8,pt;q=0.6,de;q=0.4'
}

params = {
  '__EVENTTARGET'     => '',
  '__EVENTARGUMENT'   => '',
  '__VIEWSTATE'       => form.field_with(name: '__VIEWSTATE').value,
  '__EVENTVALIDATION' => form.field_with(name: '__EVENTVALIDATION').value,
  'ctl00$ContentPlaceHolder1$Login1$UserName'    => USERNAME,
  'ctl00$ContentPlaceHolder1$Login1$Password'    => PASSWORD,
  'ctl00$ContentPlaceHolder1$Login1$LoginButton' => 'Logar'
}

mechanize.post("http://estagios.pcs.usp.br/semLogin/login.aspx", params, headers)

save_html('after_login', mechanize.page.body)

################################################
##         TODO: CONTINUE FROM HERE!          ##
################################################

if not mechanize.page.body.include? "ContentPlaceHolder1_Login1"

  #Get all job openings
  requests = []
  results = []

  valids = {}
  blanks = []
  duplicated = {}
  tests = []

  threads = []

  total = 2000

  #Break all the requests into total/100 lists
  #Keeps the number of connections under 100
  N = (total/100).ceil

  total.times do |i| 

    requests << i

  end

  requests.each_slice(requests.length/N) do |i|

    t = Thread.new {

      #Build a list, each with N requests 
      i.each do |j|

        #Uses mechanize to download those N  requests one by one
        mechanize.get("http://estagios.pcs.usp.br/aluno/vagas/exibirVaga.aspx?id=#{j}")

        #Selects useful data form the html
        doc = mechanize.page.parser
        selector = '.formulario table tr'

        #Go through the data
        data = []
        field = []

        #Get each line
        doc.css(selector).each do |line|

          #Get each column
          cols = line.css('td')

          if cols.length > 1

            #Processes the first column as title and the second as data
            data << cols[1].text.strip.force_encoding('UTF-8')
            field << cols[0].text.strip.force_encoding('UTF-8')
          
          else 
            
            break;

          end

        end

        #If the title is not empty, store the data
        if data[1].length > 1 and data[8].length > 5

          #Discard test openings
          regex = /teste:/i
          if regex.match(data[1])
            next
          end

          #Build a hash with fields and values
          hash = Hash[field.zip(data)]

          #Saves the opening ID as valid

          #Check for duplicates
          if (t = hasDuplicate(hash, valids))
            
            #If found, add to the duplicate array from the original object
            if duplicated[t]

                duplicated[t] << j

              else

                duplicated.store(t,[j]);

              end

          else

            #If not, store it in the valids hash
            valids.store(j,hash)

          end

        else

          #Adds the blank Id for later reference
          blanks << j
        end

      end

    }

    threads << t

  end

  #Runs all threads
  threads.each do |t|
    t.join
  end

  #Transforms the recieved data into a Hash
  results = {openings:{valids:valids, blanks: blanks, duplicated: duplicated}, date:Time.new}

  #Saves the Hash as a json file
  data = File.open("results.json",'w')
  data.puts results.to_json

else

  puts "Login failed"

end

#Fixes a few erros in Mechanize:
class Mechanize::HTTP::Agent
  MAX_RESET_RETRIES = 10

  # We need to replace the core Mechanize HTTP method:
  #
  #   Mechanize::HTTP::Agent#fetch
  #
  # with a wrapper that handles the infamous "too many connection resets"
  # Mechanize bug that is described here:
  #
  #   https://github.com/sparklemotion/mechanize/issues/123
  #
  # The wrapper shuts down the persistent HTTP connection when it fails with
  # this error, and simply tries again. In practice, this only ever needs to
  # be retried once, but I am going to let it retry a few times
  # (MAX_RESET_RETRIES), just in case.
  #
  def fetch_with_retry(
    uri,
    method    = :get,
    headers   = {},
    params    = [],
    referer   = current_page,
    redirects = 0
  )
    action      = "#{method.to_s.upcase} #{uri.to_s}"
    retry_count = 0

    begin
      fetch_without_retry(uri, method, headers, params, referer, redirects)
    rescue Net::HTTP::Persistent::Error => e
      # Pass on any other type of error.
      raise unless e.message =~ /too many connection resets/

      # Pass on the error if we've tried too many times.
      if retry_count >= MAX_RESET_RETRIES
        puts "**** WARN: Mechanize retried connection reset #{MAX_RESET_RETRIES} times and never succeeded: #{action}"
        raise
      end

      # Otherwise, shutdown the persistent HTTP connection and try again.
      puts "**** WARN: Mechanize retrying connection reset error: #{action}"
      retry_count += 1
      self.http.shutdown
      retry
    end
  end

  # Alias so #fetch actually uses our new #fetch_with_retry to wrap the
  # old one aliased as #fetch_without_retry.
  alias_method :fetch_without_retry, :fetch
  alias_method :fetch, :fetch_with_retry

end