# encoding: utf-8

# -----------------
# Introdução
# -----------------

# O objetivo deste exercício é avaliar como o desempenho de um determinado
# programa ou trecho de código varia de acordo com o número de threads
# utilizadas.

# Vamos avaliar o uso de threads em dois tipos de programa: o primeiro é do tipo
# "IO-intensive", isto é, um programa que gasta a maior parte do tempo em
# execuções de I/O (entrada e saída), como fazer o download de arquivos da
# Internet.

# O segundo programa é do tipo "CPU-intensive", isto é, um programa que gasta a
# maior parte do tempo fazendo cálculos (utilizando o processador).

# Para cada um destes programas, você deverá escrever três versões dele:
# 1) Uma versão sequencial (que não usa threads)
# 2) Uma versão que usa um número pequeno de threads
# 3) Uma versão que usa um número muito grande de threads

# A biblioteca de benchmark do Ruby
# (http://ruby-doc.org/stdlib-1.9.2/libdoc/benchmark/rdoc/Benchmark.html)
# será utilizada para comparar o desempenho destas diferentes versões.

# -----------------
# Exercício 6.4
# -----------------

# Importa a biblioteca de benchmark do Ruby
require 'benchmark'
require 'mechanize'

# Cada versão será executada N vezes, para garantir condições médias de
# desempenho.
N = 50_000

def links

  # Esta função baixa todos os links desta página:
  # http://en.wikipedia.org/wiki/List_of_programming_languages

  # Vamos utilizar uma biblioteca chamada Mechanize para fazer download
  # dos links.

  m = Mechanize.new

  # Baixa a página principal, que tem todos os links.
  m.get('http://en.wikipedia.org/wiki/List_of_programming_languages')

  links = m.page.links.
    map { |link| link.href }.
    select { |path| path =~ /\A\/wiki/ }.
    map { |path| "http://en.wikipedia.org/#{path}" }

  links[0..200]

end

def io_v1
  # Versão sequencial do programa IO-intensive.
  # Escreva aqui uma função que itera sobre os links retornados pela
  # função links e usa o Mechanize para baixar cada link.
  # Utilize uma nova instância do Mechanize por iteração.

  #Cria um array com todos os links
  result = links()

  result.each do |i|

    #Para cada elemento, cria um Mechanize
    a = Mechanize.new
    #E usa para fazer o download. O comando .get eh sincrono.
    a.get(i)

  end

end

def io_v2
  # Versão do IO-intensive com 10 threads.

  threads = []

  #Quebra a lista de links em 10 pedacos
  result = links().each_slice(links.length/10) { |i|

    #Faz um thread para cada pedaco
    t = Thread.new{
      #Dentro do thread, itera sobre a sub-lista recebida
      i.each do |j|
        #Cria um Mechanize e baixa cada item
        a = Mechanize.new
        a.get(j)      
      end

    }

    threads<<t

  }

  #Executa todos os threads
  threads.each do |t|
    t.join
  end

end

def io_v3
  # Versão do IO-intensive com 100 threads.

  threads = []

  #Quebra a lista de links em 100 pedacos
  result = links().each_slice(links.length/100) { |i|

    #Faz um thread para cada pedaco
    t = Thread.new{
      #Dentro do thread, itera sobre a sub-lista recebida
      i.each do |j|
        #Cria um Mechanize e baixa cada item
        a = Mechanize.new
        a.get(j)      
      end

    }

    threads<<t

  }

  #Executa todos os threads
  threads.each do |t|
    t.join
  end

end

def sum(n)
  500_000.downto(n).reduce(:+)
end

def cpu_v1
  # Versão sequencial do programa CPU-intensive.
  # Escreva uma função que chama a função sum(n) para todos os inteiros
  # entre 0 e 100.

  #Fazer 101 vezes:
  101.times do |i|
    sum(i-1)
  end

end

def cpu_v2
  # Versão do CPU-intensive com 10 threads.

  threads = []

  10.times do |i|

    list = (10*(i-1))..(10*i)

    list.each do |j|

      t = Thread.new{
      sum(j)
      }

      threads<<t

    end

  end

  threads.each do |t|
    t.join
  end

end

def cpu_v3
  # Versão do CPU-intensive com 100 threads.

  threads = []

  101.times do |i|

    t = Thread.new{
      sum(i-1)
      }

    threads<<t

  end

  threads.each do |t|
    t.join
  end

end

puts "Execução dos programas 'IO-intensive' (download de arquivos):"
puts "-------------------------------------------------------------\n\n"

Benchmark.bm do |reporter|
  reporter.report { io_v1 }
  reporter.report { io_v2 }
  reporter.report { io_v3 }
end

puts "\n\n"
puts "Execução dos programas 'CPU-intensive (cálculo de soma)':"
puts "-------------------------------------------------------------\n\n"

Benchmark.bm do |reporter|
  reporter.report { cpu_v1 }
  reporter.report { cpu_v2 }
  reporter.report { cpu_v3 }
end

#
# Escreva as suas conclusões sobre como o desempenho variou para cada versão
# (melhorou ou piorou?) e para cada tipo de programa.
#

#Para IO-Intensive, melhorou com o aumento do numero de threads.
# => Intuitivamente, podemos argumentar que estamos subutilizando a capacidade da placa de rede
# => do computador ao fazermos apenas um request por vez. O sistema pode facilmente paralelizar
# => alguns downloads, ate um certo limite. A partir dai, pode ser que nao seja mais vantajoso
# => paralelizar os requests.

#Para CPU-Intensive, o desempenho piorou com o uso de Threads.
# => Nesse caso, nao ha motivo para utilizacao de threads pois o processador nunca esta ocioso,
# => ou esperando por um dado, como eh o caso do IO-Intensive. Aqui, usar threads apenas aumenta
# => o custo computacional, ja que sao introduzidas varias instrucoes de salto entre as threads.
