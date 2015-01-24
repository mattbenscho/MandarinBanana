# -*- coding: utf-8 -*-
namespace :db do
  desc "Creating pngs of regular images and uploading to S3"
  task create_painting_pngs: :environment do
    # setting up the connection
    s3 = AWS::S3.new(:access_key_id => S3_CONFIG["access_key_id"], :secret_access_key => S3_CONFIG["secret_access_key"])
    bucket = s3.buckets[S3_CONFIG["image_bucket"]]
    Image.all.each do |i|
      # create and upload the png
      @name = i.id.to_s + ".png"
      @png = Base64.decode64(i.data['data:image/png;base64,'.length .. -1])
      obj = bucket.objects.create(@name, @png, {content_type: "image/png", ac1: "public_read"})
      puts @name
    end
  end

  desc "Creating pngs of featured images and uploading to S3"
  task create_featured_painting_pngs: :environment do
    # setting up the connection
    s3 = AWS::S3.new(:access_key_id => S3_CONFIG["access_key_id"], :secret_access_key => S3_CONFIG["secret_access_key"])
    bucket = s3.buckets[S3_CONFIG["fimage_bucket"]]
    FeaturedImage.all.each do |fi|
      # create and upload the png
      @name = fi.id.to_s + ".png"
      @png = Base64.decode64(fi.data['data:image/png;base64,'.length .. -1])
      obj = bucket.objects.create(@name, @png, {content_type: "image/png", ac1: "public_read"})
      puts @name
    end
  end
end
