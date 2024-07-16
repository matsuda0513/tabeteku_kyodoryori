namespace :scrape do
  desc "Scrape and save Kyodoryouri data"
  task kyodoryouri: :environment do
    require_relative '../../app/services/scrape_service'
    ScrapeService.fetch_and_save_all_kyodoryouri
    puts "Scraping and saving Kyodoryouri data completed."
  end
end