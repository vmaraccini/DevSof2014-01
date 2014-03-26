def upcase input

	#Migué: input.upcase
	
	#Nao migué:
	#Mapa de hash
	mapa = {"a" => "A","b" => "B","c" => "C","d" => "D","e" => "E","f" => "F","g" => "G","h" => "H","i" => "I","j" => "J","k" => "K","l" => "L","m" => "M","n" => "N","o" => "O","p" => "P","q" => "Q","r" => "R","s" => "S","t" => "T","u" => "U","v" => "V","w" => "W","x" => "X","y" => "Y","z" => "Z"}

	#Cria uma string resultado
	string = ""
	input.each_char do |c| 
		#Se o caractere esta no hash, pega o caractere resultante ao se buscar por c no hash
		if mapa[c] != nil
			string += mapa[c]
		else
		#Senao, usa o proprio. Coisas do tipo espaço, newline e pontuação cairão aqui.
			string += c
		end

	end

	#"Retorna"
	string

end

p upcase("introducao a ruby finalizada")