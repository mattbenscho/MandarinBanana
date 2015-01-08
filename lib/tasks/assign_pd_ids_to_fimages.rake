# -*- coding: utf-8 -*-
namespace :db do
  desc "Find the right pinyindefinitions for featured images based on all images' data"
  task assign_pd_ids_to_fimages: :environment do
    FeaturedImage.where(pinyindefinition_id: nil).each do |fimage|
      puts Hanzi.find(fimage.hanzi_id).character
      @image = Image.find_by(data: fimage.data)
      if !@image.nil?
        fimage.pinyindefinition_id = @image.mnemonic.pinyindefinition.id
        fimage.save
      end
    end
  end
end
