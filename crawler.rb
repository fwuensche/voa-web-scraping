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
begin
    # go to the next page
    results_page = next_link.click

    # get the results
    trs = results_page.search('tbody tr')
    trs.each do |tr|
        bar = tr.search('td.first').text
        url = tr.search('a').first['href']
        open(filename, 'a') { |f| f.puts "#{bar},#{url}" }
    end
    next_link = results_page.link_with(text: '»')
    p count+=1 if count%20 == 0
    #sleep(1)
end until next_link.nil?

p count