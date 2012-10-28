#!/usr/bin/env ruby

FACTOR = 0.55
WIDTH = 1000
HEIGHT = 200

def generate_terrain(iter,range)
	terrain = [1,1]
	rn = Random.new(5239)
	iter.times do
		i = terrain.size-1
		while i > 0
			midpoint = (terrain[i]+terrain[i-1])/2.0				
			terrain.insert(i,midpoint + rn.rand*range-range/2.0)
			i -= 1
		end
		range *= FACTOR
	end
	return terrain
end

def generate_svg(terrain,filepath)
	file = File.new(filepath,"w")
	file.puts <<-eos
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg width="12cm" height="10cm" viewBox="0 0 #{WIDTH} #{HEIGHT}" xmlns="http://www.w3.org/2000/svg" version="1.1">
<title>SVG test</title>
	eos
	file.print "<path d=\"M"
	n = terrain.size - 1
	for i in (0..n)
		x = i*(WIDTH/(terrain.size-1).to_f)
		y = HEIGHT*(1-terrain[i]/2.0)
		if (i != 0)
			file.print "L "
		end
		file.print "#{x} #{y} "
	end
	
	file.puts "\" fill=\"none\" stroke=\"black\" stroke-width=\"3\"/>"
	file.puts "</svg>"
end

terrain = generate_terrain(10,3.0)
generate_svg(terrain,"terrain.svg")
