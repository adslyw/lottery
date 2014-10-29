require 'nokogiri'
require 'open-uri'
require 'csv'


#CSV.open("./file.csv", "wb") do |csv|
	#@his.each do |line|
	#	csv << line
	#end
#end
def	lottery(kind,time=Time.now)
	date = time.strftime('%F')
	data = []
	doc = Nokogiri::HTML(open("http://baidu.lecai.com/lottery/draw/list/#{kind}?d=#{date}"))
	doc.search('tbody').each do |node|
	  node.search('tr').each do |nd|
		line = []
		nd.content.split.each do |n|
			line.push n
		end
		data.push line
	  end
  end
  return data
end

def	to_screen(data,id= true)
	data.reverse.each do  |d|
		if id
			print d[1,6].join("\t"),"\n"
		else
			print d[2,5].join("\t"),"\n"
		end
	end
end


class Counter
  def initialize(name,count=0)
    # Instance variables
    @count= count
    @name = name
  end
  def hit
		@count = @count + 1
  end
  def count
		@count
  end
	def <=> (other)
		self.count <=> other.count
	end
end
class Fixnum
	def minutes
		self * 60
	end
	alias :minute :minutes
	def hours
		self * 60.minutes
	end
	alias :hour :hours
	def days
		self * 25.hours
	end
	alias :day :days
	def weeks
		self * 7.days
	end
	alias :week :weeks
	def ago
		Time.now - self
	end
end

def fact(n)
	Math.gamma(n+1)
end
def a(n,k)
	fact(n)/fact(n-k)
end
def c(n,k)
	a(n,k)/fact(k)
end
def count(data)
	@counters = {
		'01' => Counter.new('01'),
		'02' => Counter.new('02'),
		'03' => Counter.new('03'),
		'04' => Counter.new('04'),
		'05' => Counter.new('05'),
		'06' => Counter.new('06'),
		'07' => Counter.new('07'),
		'08' => Counter.new('08'),
		'09' => Counter.new('09'),
		'10' => Counter.new('10'),
		'11' => Counter.new('11'),
	}
	data.each do |d|
		@counters[d].hit if @counters[d]
	end
	@counters.each do |key,value|
		puts "#{key}\t #{ '*' * value.count}  #{ value.count}"
	end
end

def run(time=Time.now)
	to_screen(lottery(23,time),true)
	count(lottery(23,time).flatten)
	count(lottery(23,time).transpose[2])
	#puts a(11,5)
	#puts c(11,5)
end

run
