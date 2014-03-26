def ordena (arr)
	#Migué: arr.sort

	#Não migué:

	if arr.size < 2 
		return arr
	end

	pivo = arr[arr.size.floor]
	arr.delete[pivo]

	men = []
	mai = []

	for arr.each do |elemento|

		if elemento < pivo
			men.push[elemento]
		elsif elemento > pivo
			mai.push[elemento]
		end
	end

	return men,pivo,maior

end

p ordena([20,0,50,30,34,33,35,22,1])