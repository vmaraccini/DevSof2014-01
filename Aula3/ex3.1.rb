def imprime_num_letras nome
	#Itera sobre todos os caracteres da string (enumerator)
	nome.each_char {
		#Imprime sem newline
		print "-"

	}

end

#Chama a funcao com meu nome
imprime_num_letras ("Victor Gabriel Maraccini")