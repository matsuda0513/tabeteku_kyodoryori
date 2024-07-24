namespace :scrape do
  desc "Scrape and save English Kyodoryouri data"
  task english_kyodoryouri: :environment do
    require_relative '../../app/services/english_scrape_service'
    EnglishScrapeService.fetch_and_save_all_english_kyodoryouri
    puts "Scraping and saving English Kyodoryouri data completed."
  end

  # # 特定のIDを更新するための一時的なタスク
  # desc "Scrape and update kyodoryouri data by ID"
  # task :kyodoryouri_by_id, [:id] => :environment do |t, args|
  #   require_relative '../../app/services/scrape_service'
  #   ScrapeService.fetch_and_save_kyodoryouri_by_id(args[:id])
  #   puts "Scraping and updating Kyodoryouri data for ID #{args[:id]} completed."
  # end
end