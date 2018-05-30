# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

# Add files and commands to this file, like the example:
#   watch(%r{file/path}) { `command(s)` }
#
def function(str)
  ary = []
  File.open("hoge.txt").each do |e|
    /wbee (\d+)/ =~ e
    ary << $1
  end

  return %Q(#{Time.now.strftime("Printed on %k:%M::%m/%d/%Y").to_s} :: #{ary})
end

guard :shell do
  watch(%r{hoge.txt}) {|m| File.open("./log.log", "a"){|fp| fp << "#{function(m[0])}\n"}}
end