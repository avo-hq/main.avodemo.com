# RubyEncoder v3 loader
_v = RUBY_VERSION.scan(/^\d+\.\d+\.\d+/)[0].delete('.')
_v = '' if _v.to_i < 190
_p = RUBY_PLATFORM.scan(/([A-Za-z0-9_]+)-([A-Za-z_]+)/)[0]
_d = File.expand_path(File.dirname(__FILE__))
[_v+'.'+_p[1]+'.'+_p[0],_v+'.'+_p[1],_v[0..1]+'.'+_p[1]+'.'+_p[0],_v[0..1]+'.'+_p[1]].each do |f|
    f = _d + '/rgloader' + f 
    $LOADED_FEATURES.reject!{|p| p.start_with?(f)}
    begin
	require f and break
    rescue LoadError
    end
end
if !defined?(RGLoader) then 
  raise LoadError, "The RubyEncoder loader is not installed. Please visit the http://www.rubyencoder.com/loaders/ RubyEncoder site to download the required loader for '"+_p[1]+"' and unpack it into '"+_d+"' directory to run this protected script."
end
