require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper


def self.scrape_index_page(index_url)
    student_hash = {}
    scraped_students =  []
    doc = Nokogiri::HTML(open("./fixtures/student-site/index.html"))
    student_cards = doc.css("div.student-card")
    student_cards.each {|student|
         student_location = student.css("p").text
         student_name = student.css("h4").text
         student_url = student.css("a").attribute("href").value
         student_hash = {:name => student_name, :location => student_location, :profile_url => student_url}
         scraped_students << student_hash
         }
         scraped_students
end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student_hash = {}

   	doc.css('div.social-icon-container a').each {|link_element|
   		link = link_element.attribute('href').value
   		case link
   		when /twitter/
   			student_hash[:twitter] = link
   		when /github/
   			student_hash[:github] = link
   		when /linkedin/
   			student_hash[:linkedin] = link
   		else
   			student_hash[:blog] = link
   		end
   	}
   	student_hash[:profile_quote] = doc.css('div.profile-quote').text
   	student_hash[:bio] = doc.css('div.description-holder p').text
   	student_hash
  end

end
