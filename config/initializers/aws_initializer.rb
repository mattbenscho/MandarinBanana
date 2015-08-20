S3_CONFIG = YAML.load_file("#{::Rails.root}/config/aws.yml")[Rails.env]

# Load local AWS keys if available.
keys = "#{::Rails.root}/config/aws_keys.csv"
if File.exists?(keys)
  File.open(keys).each do |line|
    ENV["S3_KEY_ID"] = line.split(",").first
    ENV["S3_SECRET"] = line.split(",").last.chomp
  end
end

