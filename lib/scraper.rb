require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students_list = []

    doc = Nokogiri::HTML(open(index_url))

    doc.css(".roster-cards-container .student-card").each do |student|
      students_list << {
        :name => student.css(".student-name").text,
        :location => student.css(".student-location").text,
        :profile_url => student.css("a").attr("href").value
      }
    end

    students_list
  end

  def self.scrape_profile_page(profile_url)
    student_attributes = {}

    doc = Nokogiri::HTML(open(profile_url))

    doc.css(".social-icon-container a").each do |social|
      if social.css(".social-icon").attr("src").value == "../assets/img/twitter-icon.png"
        student_attributes[:twitter] = social.attr("href")
      elsif social.css(".social-icon").attr("src").value == "../assets/img/linkedin-icon.png"
        student_attributes[:linkedin] = social.attr("href")
      elsif social.css(".social-icon").attr("src").value == "../assets/img/github-icon.png"
        student_attributes[:github] = social.attr("href")
      elsif social.css(".social-icon").attr("src").value == "../assets/img/rss-icon.png"
        student_attributes[:blog] = social.attr("href")
      end
    end

    student_attributes[:profile_quote] = doc.css(".vitals-text-container .profile-quote").text
    student_attributes[:bio] = doc.css(".details-container .bio-content .description-holder p").text

    student_attributes
  end

end
