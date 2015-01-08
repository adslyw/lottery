require 'matrix'
require 'nokogiri'
require 'open-uri'
class Game
  def initialize(kind,m,n)
    @kind = kind
    @hits = Array.new(n+1){Array.new(m+1){0}}
    @data = []
  end

  def hit(i, j)
    @hits[i-1][j-1]
  end
  def hits
    @hits
  end
  def update_data(time = Time.now)
    date = time.strftime('%F')
    data_source = "http://baidu.lecai.com/lottery/draw/list/#{@kind}?d=#{date}"
    doc = Nokogiri::HTML(open(data_source))
    doc.search('tbody').each do |node|
      node.search('tr').each do |nd|
      line = []
      nd.content.split.each do |n|
        line.push n
      end
      @data.push line
      end
    end
    puts "Data updated."
  end
  def update_hits
     temp = @data.transpose[2,5].transpose
     temp.each do |p1,p2,p3,p4,p5|
       @hits[1][p1.to_i] = @hits[1][p1.to_i].succ
       @hits[2][p2.to_i] = @hits[2][p2.to_i].succ
       @hits[3][p3.to_i] = @hits[3][p3.to_i].succ
       @hits[4][p4.to_i] = @hits[4][p4.to_i].succ
       @hits[5][p5.to_i] = @hits[5][p5.to_i].succ
     end
     p @hits
  end
  def hint
    print "q for quit\nu for update data\ns for screen show\nh for show hint\nt for show hits\np for predict\n"
  end

  def to_screen
    @data.reverse.each do  |d|
        print d,"\n"
    end
  end
  def predict
    puts ""
  end
  def run
    main = Thread.new{
      hint
      keeprunning = true
      while(keeprunning) do
        command = gets
        case command.chop!
        when 'h'||'H' then hint
        when 'q'||'Q' then keeprunning = false
        when 'u'||'U' then update_data
        when 's'||'S' then to_screen
        when 't'||'T' then update_hits
        when 'p'||'P' then predict
        end
      end
    }
    main.run
    main.join
  end
end

g = Game.new(23,11,5).run
#p g.hits
