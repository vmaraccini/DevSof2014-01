def ordena (arr)
    #Migué: arr.sort

    #Não migué:
    mudou = true
    i = 0;
    
    #Tipo bubble sort:
	while mudou do
        #Retorna direto no caso base
        if i >= arr.size
            i = 0;
        end
        
        #Inicializa o flag como nao e espera um sim.
        #Se passarmos por todo o vetor e nao houverem trocas, ele esta ordenado.
        mudou = false
        for i in 0..(arr.size-2) do
            #Se há diferença, trocar de posição
            if arr[i+1] < arr[i]
                #Troca de posicao usando easy swap do ruby
                arr[i],arr[i+1] = arr[i+1],arr[i]
                mudou = true
            end
        end
            
    end
    
    return arr
    
end

p ordena([20,0,50,30,34,33,35,22,1])
