def fatorial n
	#Se caso base, retornar 1
	return 1 if (n==1)
	#Caso contrario, usar recursividade
	fatorial(n-1)*n

end

#Imprimir o resultado da chamada para fatorial de 20
p fatorial (20)