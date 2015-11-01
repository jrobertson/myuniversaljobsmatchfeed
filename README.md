# Generating an RSS feed for the search results from the myuniversaljobsmatch gem

    require 'myuniversaljobsmatchfeed'

    feed = MyUniversalJobsMatchFeed.new \
        '/home/james/jamesrobertson.eu/jobsearch/ujm', \
           title: 'Administrative', where: 'edinburgh', \ 
      url_base: 'http://www.jamesrobertson.eu/jobsearch',\
                           dx_xslt: '/xsl/dynarex-b.xsl', \
                                rss_xslt: '/xsl/feed.xsl', \
     target_xslt: 'http://www.jamesrobertson.eu/xsl/target.xsl'

    feed.update

The above code creates an RSS feed for the search results from the myuniversaljobsmatch gem. At the time of writing this gem is still under development.

myuniversaljobsmatchfeed gem myuniversaljobsmatch jobsearch
