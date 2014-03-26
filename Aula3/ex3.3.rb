def ordena (arr)
	#Migué: arr.sort

	#Não migué:
	ordenado = FALSE
	while !ordenado do
		
		for 0.upto(arr.size - 1) do

			if arr[i] > arr[i+1]
					temp = arr[i]
					arr[i] = arr[i+1]
					arr[i+1] = temp
			end

		end

	end

	arr

end

p ordena([20,0,50,30,34,33,35,22,1])