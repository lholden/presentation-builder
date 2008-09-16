def build
  open(Config.destination_file, 'w') do |out|
    out << process
  end
end