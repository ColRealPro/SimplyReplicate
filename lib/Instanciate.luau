return function(instance: string, props: { [string]: any })
	local element = Instance.new(instance)

	for key, value in props do
		element[key] = value
	end

	return element
end
