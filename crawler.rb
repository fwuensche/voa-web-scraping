# we'll scrape properties' reference and url

# open the website
require 'mechanize'
agent = Mechanize.new
page = agent.get('http://www.2010.voa.gov.uk/rli/en/basic/find')

# fill the search form
form = page.forms.first
form['searchTerm'] = 'sw16'
results_page = form.submit

results = []
filename = 'crawling_results.csv'
File.write(filename, '')
next_link = results_page.link_with(text: '»')

count = 0
# until there is no next page
until next_link.nil?
    # go to the next page
    results_page = next_link.click

    # get the results
    properties = results_page.search('tbody tr')
    properties.each do |property|
        barcode = property.search('td.first').text
        url = property.search('a').first['href']
        open(filename, 'a') { |f| f.puts "#{barcode},#{url}" }
    end
    next_link = results_page.link_with(text: '»')
    
    # print out every multiple of 20 (just for visual feedback)
    p count += 1 if count % 20 == 0
end

# print total number of scraped properties
p "You've just scraped: #{count} properties"
