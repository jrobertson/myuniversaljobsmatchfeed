#!/usr/bin/env ruby

# file: myuniversaljobsmatchfeed.rb

require 'daily_notices'
require 'myuniversaljobsmatch'



class MyUniversalJobsMatchFeed < DailyNotices

  def initialize(filepath='', title: nil, where: nil, url_base: '', \
                  dx_xslt: nil, rss_xslt: nil, refreshrate: nil, target_xslt: '')

    @schema = 'ujm[title,tags]/item(job_id, title, description, ' + \
                   'posting_date, company, location, industries, ' + \
                   'job_type, salary, hours_of_work, job_reference_code,' + \
                   'career_level, education_level, application_methods,' + \
                   'years_of_experience)'
    @default_key = 'job_id'
        
    super(filepath, url_base: url_base, dx_xslt: dx_xslt, \
          rss_xslt: rss_xslt, target_page: :record, target_xslt: target_xslt)

    @title, @where = title, where
    
    self.title = "My Universal Jobmatch feed for %s in %s" % [title, where]
    self.description = 'Universal Jobmatch data fetched ' + \
                                                 'from jobsearch.direct.gov.uk'
    
    # set the time last updated in the hidden scratch file if refreshrate set
    
    @datafile = File.join(@filepath, '.myuniversaljobsmatchfeed')
    @refreshrate = refreshrate
          
      
    if @refesh_rate then
      
      @h =  File.exists?(@datafile) ? Kvx.new(File.read(@datafile)).to_h : \
                                                   {nextrefresh: Time.now.to_s}
    end
    
    @ujm = MyUniversalJobsMatch.new filepath: @filepath

  end
  
  def start()
    loop { self.update; sleep((@refreshrate || 1) * 60) }
  end

  def update()

    return if @refreshrate and (Time.parse(@h[:nextrefresh]) > Time.now)

    results = @ujm.search(title: @title, where: @where)
    results_filepath = File.join(@filepath, 'results.xml')
    
    capture = ->(result) do
      vacancy = @ujm.query result[:job_id]

      
      self.add(vacancy, title: vacancy[:title], \
             description: vacancy[:description], id: vacancy[:job_id].rstrip) do |kvx|
        kvx.summary[:title] = vacancy[:title]
      end      
    end
    
    if File.exists? results_filepath then
      
      prev_results = Dynarex.new(results_filepath)
      new_results = results.to_a - prev_results.to_a
            
      if new_results.any? then
        
        new_results.each(&capture)
                
        results.save results_filepath
        on_change()
        
      end
      
    else
      
      results.all.each(&capture)
              
      results.save results_filepath
      on_change()      
      
    end

    if @refreshrate then
      
      @h = {nextrefresh: (Time.now + @refreshrate * 60).to_s}
      File.write @datafile, Kvx.new(@h)
      
    end

  end

  # override this method for your own custom notifier, callback, or webhook etc.
  #
  def on_change()

    yield() if block_given?
    
  end
  
  private
  
  def create_link(id)
    [File.join(@url_base, File.basename(@filepath), \
                                            @archive_path, id)].join('/')
  end  

end