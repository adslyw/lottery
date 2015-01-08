require 'nokogiri'
require 'open-uri'
doc = Nokogiri::HTML(open("http://baidu.lecai.com/lottery/draw/list/561?d=2015-01-08"))

doc.search('tbody').each do |node|
  @hits =  node.content.split().each_slice(6).to_a
end

 @data = @hits.map { |e| e[2,3].map { |e| e.to_i } }
 @sums = @data.map { |e| e[0]+e[1]+e[2]  }
 @targets = [3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]

 win = [240,80,40,25,16,12,10,9,9,10,12,16,25,40,80,240]
 hit = [1,3,6,10,15,21,25,27,27,25,21,15,10,6,3,1]


 @data.map { |e| puts e.join("\t")+"\t#{e[0]+e[1]+e[2]}"  }
 @pe= hit.map{ |e| Rational(e, 216) }
 @hope = @pe.map { |e| e*@sums.size }
p @hits.size
 @targets.each_index { |i| print "[#{@targets[i]}]:\t#{@sums.count(@targets[i])}\t(#{(@pe[i]*78).to_f.round(3)})\t#{@sums.count(@targets[i]) > @pe[i]*78 ? "+":"-"}\n" }

 buy = [0,0,0,1,1,1,5,20,20,5,1,1,1,0,0,0]
 gold = 0
 @pe.each_index { |i| gold += ((@pe[i]*win[i] - 2) * buy[i])}
 p gold.to_f
