Connecting to an API and Making a Word Cloud
================
Justin Post

## Goals

  - Understand very basics of APIs

  - Contact an API using R

  - Process returned data

  - Create a word cloud

## APIs

Application Programming Interfaces (APIs) - a defined method for asking
for information from a computer

  - [List of APIs](https://www.programmableweb.com/apis/directory)

  - Important for grabbing data, often returned in JSON format

  - Expand opportunities by allowing your students to get data they are
    interested in\!

>   - Very few packages for contacting APIs are out there for R (as
>     compared to say python)

>   - Can do it yourself using `httr` package\!

## Steps to obtain data

  - Install packages needed for contacting APIs and handling data
    
      - `httr` and `jsonlite`

  - (Usually) Obtain a key by registering at the API you want to contact

  - Construct a **URL** to obtain data (using `GET()`)

  - Process data using `jsonlite` functions

## Example <https://newsapi.org/>

Registered for a key at [newsapi.org](https://newsapi.org/). An API for
looking at news articles

  - Look at documentation for API (most have this\!)

  - Example URL to obtain data is given

`https://newsapi.org/v2/everything?q=bitcoin&apiKey=myKeyGoesHere`

## Example <https://newsapi.org/>

  - Can add in date for instance:

<img src="dates.PNG" width="75%" style="display: block; margin: auto;" />

`https://newsapi.org/v2/everything?q=bitcoin&from=2021-06-01&apiKey=myKeyGoesHere`

## Using R to Obtain the Data

  - Use `GET` from `httr` package (make sure to load package\!)

  - Modify for what you have interest in\!

<!-- end list -->

``` r
library(httr)
GET("http://newsapi.org/v2/everything?qlnTitle=Juneteenth&from=2021-06-01&language=en&
    apiKey=myKeyGoesHere")
```

## Returned data

  - Usually what you want is stored in something like `content`

<!-- end list -->

``` r
str(myData, max.level = 1)
```

    ## List of 10
    ##  $ url        : chr "http://newsapi.org/v2/everything?qInTitle=Juneteenth&from=2021-06-01&language=en&pageSize=100&apiKey=aa4b545bfb"| __truncated__
    ##  $ status_code: int 200
    ##  $ headers    :List of 15
    ##   ..- attr(*, "class")= chr [1:2] "insensitive" "list"
    ##  $ all_headers:List of 1
    ##  $ cookies    :'data.frame': 0 obs. of  7 variables:
    ##  $ content    : raw [1:84391] 7b 22 73 74 ...
    ##  $ date       : POSIXct[1:1], format:  ...
    ##  $ times      : Named num [1:6] 0 0.0206 0.0419 0.042 0.1967 ...
    ##   ..- attr(*, "names")= chr [1:6] "redirect" "namelookup" "connect" "pretransfer" ...
    ##  $ request    :List of 7
    ##   ..- attr(*, "class")= chr "request"
    ##  $ handle     :Class 'curl_handle' <externalptr> 
    ##  - attr(*, "class")= chr "response"

## Parse with `jsonlite`

Common steps:

  - Grab the list element we want  
  - Convert it to characters (it will have a JSON structure)  
  - Convert it to a data frame with `fromJSON` from the `jsonlite`
    package

<!-- end list -->

``` r
library(dplyr)
library(jsonlite)
parsed <- myData$content %>% rawToChar() %>% fromJSON()
str(parsed, max.level = 1)
```

    ## List of 3
    ##  $ status      : chr "ok"
    ##  $ totalResults: int 1079
    ##  $ articles    :'data.frame':    100 obs. of  8 variables:

## Inspecting article info

``` r
parsed$articles %>% 
  select(author, source, title, description, everything())
```

    ##                                            author
    ## 1                                    Trish Bendix
    ## 2              Amelia Nierenberg and David Poller
    ## 3                                  Tariro Mzezewa
    ## 4                           Isabella GrullÃ³n Paz
    ## 5                                 Luke Broadwater
    ## 6                 Annie Karni and Luke Broadwater
    ## 7                                   Laura Zornosa
    ## 8                                   Alyssa Lukpat
    ## 9                https://www.facebook.com/bbcnews
    ## 10       Dana Rubinstein and Luis FerrÃ©-SadurnÃ­
    ## 11                                   Kenny Herzog
    ## 12                                        Reuters
    ## 13                                        Reuters
    ## 14                                        Reuters
    ## 15                                  Reuters Staff
    ## 16                                        Reuters
    ## 17                                   Makini Brice
    ## 18                                  Reuters Staff
    ## 19                  W. James Antle III, Columnist
    ## 20                               Jason Weisberger
    ## 21                                    Katie Olsen
    ## 22                               Elizabeth Segran
    ## 23                                     Alana Wise
    ## 24  oseddiq@insider.com (Oma Seddiq,Eliza Relman)
    ## 25                                   Kenny Herzog
    ## 26                                   Vanessa Romo
    ## 27   gpanetta@businessinsider.com (Grace Panetta)
    ## 28                                     Maya Brown
    ## 29                                  Reuters Staff
    ## 30                                  Kevin Freking
    ## 31           Bonnie Kristian, Contributing editor
    ## 32                                  Kevin Freking
    ## 33                                  Brittany Wong
    ## 34                           The Associated Press
    ## 35                 KEVIN FREKING Associated Press
    ## 36                          Kellie Carter Jackson
    ## 37                                   Libby Cathey
    ## 38                                Justin McFarlin
    ## 39                               Maydha Devarajan
    ## 40                                     Devna Bose
    ## 41            Brigid Kennedy, Contributing Writer
    ## 42                                   Weston Blasi
    ## 43                                 Alison Kuznitz
    ## 44                                    Joe Marusak
    ## 45                                Nneka D. Dennie
    ## 46                                      Lee Moran
    ## 47                                David Pescovitz
    ## 48                               Yahoo News Video
    ## 49                     Peter Weber, Senior editor
    ## 50                       Paul Blest, chloe angyal
    ## 51                    Guardian staff and agencies
    ## 52                             USA TODAY, Editors
    ## 53         USA TODAY, Javonte Anderson, USA TODAY
    ## 54        USA TODAY, Savannah Behrmann, USA TODAY
    ## 55                                   Libby Cathey
    ## 56                USA TODAY, Jenna Ryu, USA TODAY
    ## 57                        Jazzmine | Dash of Jazz
    ## 58                             Carron J. Phillips
    ## 59                                   Sytonia Reid
    ## 60                               Kansas City Star
    ## 61                                   Meiko Temple
    ## 62                                TOM FOREMAN Jr.
    ## 63                              Tasneem Nashrulla
    ## 64                                  Madison Bloom
    ## 65                                    Janell Ross
    ## 66                                           <NA>
    ## 67                                      Macy Gray
    ## 68                                   Skylar Laird
    ## 69                               Marquise Francis
    ## 70                                   Will Coleman
    ## 71                                       LA Times
    ## 72                                     April Ryan
    ## 73         Arit John, Julissa James, Kailyn Brown
    ## 74                                  Asta Hemenway
    ## 75                                   Meiko Temple
    ## 76                               Victor Reklaitis
    ## 77                                            Ben
    ## 78                                   Cameron Koch
    ## 79                               Sarah Al-Arshani
    ## 80                                      Stephanie
    ## 81                                Hannah Wolansky
    ## 82                             Nolan D. McCaskill
    ## 83                                      The Onion
    ## 84                                     Dara Prant
    ## 85                                 Claire Shaffer
    ## 86                                      TMZ Staff
    ## 87      info@hypebeast.com (HYPEBEAST), HYPEBEAST
    ## 88                              Meera Jagannathan
    ## 89                                     Hasit Shah
    ## 90                                  Joe Wituschek
    ## 91                                     Al Jazeera
    ## 92                                 Fabiola Cineas
    ## 93                                    Andrew Mach
    ## 94                               Nick Niedzwiadek
    ## 95                                             AP
    ## 96                                    David Cohen
    ## 97                                     Mike Avila
    ## 98                                    Clint Smith
    ## 99                                       jillg366
    ## 100                                           NPR
    ##              source.id         source.name
    ## 1                 <NA>      New York Times
    ## 2                 <NA>      New York Times
    ## 3                 <NA>      New York Times
    ## 4                 <NA>      New York Times
    ## 5                 <NA>      New York Times
    ## 6                 <NA>      New York Times
    ## 7                 <NA>      New York Times
    ## 8                 <NA>      New York Times
    ## 9             bbc-news            BBC News
    ## 10                <NA>      New York Times
    ## 11                <NA>        Entrepreneur
    ## 12             reuters             Reuters
    ## 13             reuters             Reuters
    ## 14             reuters             Reuters
    ## 15             reuters             Reuters
    ## 16             reuters             Reuters
    ## 17             reuters             Reuters
    ## 18             reuters             Reuters
    ## 19                <NA> Yahoo Entertainment
    ## 20                <NA>         Boing Boing
    ## 21                <NA>        Cool Hunting
    ## 22                <NA>        Fast Company
    ## 23                <NA>                 NPR
    ## 24    business-insider    Business Insider
    ## 25                <NA>        Entrepreneur
    ## 26                <NA>                 NPR
    ## 27    business-insider    Business Insider
    ## 28                <NA> Yahoo Entertainment
    ## 29             reuters             Reuters
    ## 30                <NA>          Ctvnews.ca
    ## 31                <NA> Yahoo Entertainment
    ## 32                <NA>         Global News
    ## 33                <NA>            HuffPost
    ## 34            abc-news            ABC News
    ## 35            abc-news            ABC News
    ## 36                <NA>        The Atlantic
    ## 37            abc-news            ABC News
    ## 38                <NA> Yahoo Entertainment
    ## 39                <NA> Yahoo Entertainment
    ## 40                <NA> Yahoo Entertainment
    ## 41                <NA> Yahoo Entertainment
    ## 42                <NA>         MarketWatch
    ## 43                <NA> Yahoo Entertainment
    ## 44                <NA> Yahoo Entertainment
    ## 45                <NA>      Slate Magazine
    ## 46                <NA>            HuffPost
    ## 47                <NA>         Boing Boing
    ## 48                <NA> Yahoo Entertainment
    ## 49                <NA> Yahoo Entertainment
    ## 50           vice-news           Vice News
    ## 51                <NA>        The Guardian
    ## 52           usa-today           USA Today
    ## 53           usa-today           USA Today
    ## 54           usa-today           USA Today
    ## 55            abc-news            ABC News
    ## 56           usa-today           USA Today
    ## 57                <NA>          Food52.com
    ## 58                <NA>            Deadspin
    ## 59                <NA> Yahoo Entertainment
    ## 60                <NA> Yahoo Entertainment
    ## 61                <NA>       Thekitchn.com
    ## 62                <NA> Yahoo Entertainment
    ## 63                <NA>       BuzzFeed News
    ## 64                <NA>           Pitchfork
    ## 65                time                Time
    ## 66                <NA>        The Guardian
    ## 67                <NA>         MarketWatch
    ## 68                <NA> Yahoo Entertainment
    ## 69                <NA> Yahoo Entertainment
    ## 70                <NA>       Thekitchn.com
    ## 71                <NA> Yahoo Entertainment
    ## 72                <NA> Yahoo Entertainment
    ## 73                <NA> Yahoo Entertainment
    ## 74                <NA> Yahoo Entertainment
    ## 75                <NA>       Thekitchn.com
    ## 76                <NA>         MarketWatch
    ## 77                <NA>        Adafruit.com
    ## 78                <NA>            GameSpot
    ## 79                <NA>             INSIDER
    ## 80                <NA>        Adafruit.com
    ## 81                <NA>        Theonion.com
    ## 82            politico            Politico
    ## 83                <NA>        Theonion.com
    ## 84                <NA>         Fashionista
    ## 85                <NA>       Rolling Stone
    ## 86                <NA>                 TMZ
    ## 87                <NA>           HYPEBEAST
    ## 88                <NA>         MarketWatch
    ## 89                <NA>        Quartz India
    ## 90                <NA>               iMore
    ## 91  al-jazeera-english  Al Jazeera English
    ## 92                <NA>                 Vox
    ## 93           bloomberg           Bloomberg
    ## 94            politico            Politico
    ## 95           the-hindu           The Hindu
    ## 96                <NA>              Adweek
    ## 97                <NA>      The Points Guy
    ## 98                <NA>  Theparisreview.org
    ## 99                <NA>            Deadline
    ## 100               <NA>                 NPR
    ##                                                                                                                                             title
    ## 1                                                                                  Stephen Colbert Celebrates Americaâ\200\231s New Holiday, Juneteenth
    ## 2                                                                                 Obamacare, Juneteenth, Comedies: Your Thursday Evening Briefing
    ## 3                                                                                          What Does It Mean to Be Crowned â\200\230Miss Juneteenthâ\200\231?
    ## 4                                                                              Most Americans Know Little or Nothing About Juneteenth, Poll Finds
    ## 5                                                                                          House Passes Bill to Make Juneteenth a Federal Holiday
    ## 6                                                                                             Biden Signs Law Making Juneteenth a Federal Holiday
    ## 7                                                                                    Juneteenth: 7 Events for Celebrating the Holiday in New York
    ## 8                                                                           These 14 House Republicans Voted Against a Juneteenth Federal Holiday
    ## 9                                                                             Juneteenth: What is the newest US holiday and how is it celebrated?
    ## 10                                                                                     N.Y.C. Workers Will Not Have a Paid Day Off for Juneteenth
    ## 11                                                                                       More Companies Have Designated Juneteenth a Paid Holiday
    ## 12                                                                    JPMorgan, UBS to allow U.S. employees take day off for Juneteenth - Reuters
    ## 13                                                                      Factbox: What is Juneteenth and how are people marking the day? - Reuters
    ## 14                                                           Biden to sign Juneteenth bill, creating holiday marking U.S. slavery's end - Reuters
    ## 15                                                     U.S. CDC delays meet on heart risk from COVID-19 shots due to Juneteenth holiday - Reuters
    ## 16                                                   U.S. SEC to close its offices Friday to observe the new Juneteenth federal holiday - Reuters
    ## 17                                                              U.S. Congress votes to create Juneteenth holiday marking end of slavery - Reuters
    ## 18                                               U.S. SEC to close its offices Friday to observe the new Juneteenth federal holiday - Reuters.com
    ## 19                                                                                                    The self-defeating opposition to Juneteenth
    ## 20                                                                  Plantation removes racist Juneteenth celebration advertisement, cancels event
    ## 21                                                                                                                             Juneteenth T-Shirt
    ## 22                                                                                   How 14 Black creatives got 800 companies to honor Juneteenth
    ## 23                                                                         Senate Unanimously Approves A Bill To Make Juneteenth A Public Holiday
    ## 24                                                                 Biden makes Juneteenth a national holiday, giving federal employees Friday off
    ## 25                                                            Meet the New CEO Laying Groundwork for Corporate Equity Just In Time for Juneteenth
    ## 26                                                               Juneteenth Is Now A U.S. Holiday. Here's One Woman Behind The Decades-Long Fight
    ## 27                                                                             Trump claimed that he 'made Juneteenth very famous,' new book says
    ## 28                                                                                   Juneteenth 2021: Hereâ\200\231s a list of weekend events across SC
    ## 29                                          RPT-UPDATE 1-JPMorgan, UBS, Wells Fargo to allow U.S. employees take day off for Juneteenth - Reuters
    ## 30                                                              Juneteenth: US will soon have new holiday commemorating end of slavery - CTV News
    ## 31                                                                                               Juneteenth may finally get its due from Congress
    ## 32                                                                      Biden to sign bill making Juneteenth a U.S. federal holiday - Global News
    ## 33                                                                                  Donâ\200\231t Treat Juneteenth As Another Day Off. Do This Instead.
    ## 34                                                                                    EXPLAINER: The story of Juneteenth, the new federal holiday
    ## 35                                                                                      Senate approves bill to make Juneteenth a federal holiday
    ## 36                                                                                                 What the Push to Celebrate Juneteenth Conceals
    ## 37                                                                               Congress passes legislation to make Juneteenth a federal holiday
    ## 38                                          This Juneteenth, erase Robert E. Leeâ\200\231s name, but not his history as this nationâ\200\231s enemy | Opinion
    ## 39                                                                     â\200\230Not just a day offâ\200\231: Town of Cary approves Juneteenth as paid holiday
    ## 40                                                          NC plantation calls slaveowner a â\200\230white refugeeâ\200\231 in racist Juneteenth event promo
    ## 41                                 The Republicans who voted against the Juneteenth holiday think it will â\200\230create confusionâ\200\231 alongside July 4
    ## 42                                                                                                                          : What is Juneteenth?
    ## 43                                                           Meck ends contract with Historic Latta nonprofit over controversial Juneteenth event
    ## 44                                                             NC plantation: No apology, slams mayor and other critics of Juneteenth event promo
    ## 45                                                                         Why Federal Recognition of Juneteenth Feels Like Such an Empty Gesture
    ## 46                                                                         94-Year-Old Has â\200\230Off The Chainâ\200\231 Response To New Juneteenth Holiday
    ## 47                                                         Juneteenth: "Emancipation is a marker of progress for white Americans, not black ones"
    ## 48                                                                                                Biden: Signing Juneteenth holiday bill an honor
    ## 49                                Jimmy Fallon and Stephen Colbert cheer the new Juneteenth holiday, jeer the 14 congressmen who voted against it
    ## 50                                                                      Republicansâ\200\231 Worst Excuses for Not Wanting a Juneteenth Federal Holiday
    ## 51                                                                                                 US poised to make Juneteenth a federal holiday
    ## 52                                                  Biden signs Juneteenth bill, infrastructure bill, US Open tees off: 5 things to know Thursday
    ## 53                                                        Juneteenth is a celebration of freedom from slavery. But it didn't mean freedom for all
    ## 54                                                              House to vote Wednesday on bill to make June 19, or Juneteenth, a federal holiday
    ## 55                                                              Biden signs bill making Juneteenth, marking the end of slavery, a federal holiday
    ## 56                                                                     Usher attends signing to make Juneteenth a federal holiday: 'Long overdue'
    ## 57                                                                                    44 Recipes From Black Food Bloggers to Celebrate Juneteenth
    ## 58                                                                                            Juneteenth is being hijacked from African-Americans
    ## 59                                                                    Chicago mayor changes course, announces Juneteenth an official city holiday
    ## 60                                                                                      On The Vine: This Juneteenth Iâ\200\231m thankful for hypocrisy
    ## 61                                                                           Meiko Temple's Watermelon Limeade Belongs at Your Juneteenth Cookout
    ## 62                                                                                    Event on Juneteenth depicting fugitive slave owner canceled
    ## 63                                                Congress Has Made Juneteenth A National Holiday. Just Donâ\200\231t Talk About The Legacy Of Slavery.
    ## 64                                                                                         Bandcamp Announces Second Annual Juneteenth Fundraiser
    ## 65             Juneteenth Isnâ\200\231t Just a Celebration of the End of Slavery. We Also Honor the Black Americans Who Helped Create Their Own Freedom
    ## 66                                              Biden signs bill marking Juneteenth as federal holiday celebrating end of slavery in US â\200“ video
    ## 67                                                                                    Outside the Box: For Juneteenth, itâ\200\231s time for a new flag
    ## 68                                                          Juneteenth is now a federal holiday. Hereâ\200\231s what will be closed in Kansas City area
    ## 69                                          American celebrations of Juneteenth continue to multiply 158 years following the abolition of slavery
    ## 70                                                                     Will Coleman's Southern-Inspired Trifle Will Be a New Juneteenth Tradition
    ## 71                                                            'Red Drinks for Juneteenth,' a free, virtual event from Los Angeles Times Food Bowl
    ## 72                                                            Biden signs law making Juneteenth a federal holiday â\200” but some remain unimpressed
    ## 73                                                                 You never forget your first Juneteenth. Let these Black Angelenos tell you why
    ## 74                                                                             Juneteenth is now a federal holiday. How can I celebrate in Miami?
    ## 75                                                                Meiko Temple's Kansas City-Style BBQ Chicken Wings Are a Juneteenth Showstopper
    ## 76                                                                     Capitol Report: When does the Juneteenth holiday go into effect? Right now
    ## 77                                                                                  Adafruit Celebrates Juneteenth 2021 #Juneteenth #Emancipation
    ## 78                                                                                           Knockout City Adding Free Juneteenth Items This Week
    ## 79                    A North Carolina plantation canceled a Juneteenth event that would have told the stories of 'white refugees' after backlash
    ## 80                                                                                                                             Juneteenth at NYPL
    ## 81                                       Senate Votes To Make Juneteenth Federal Holiday So Long As No One Thinks Too Hard About Its Significance
    ## 82                                                                                        Senate passes bill to make Juneteenth a federal holiday
    ## 83                                                                                                             Juneteenth Becomes Federal Holiday
    ## 84                            Must Read: Dolce & Gabbana Is Still Not Welcome in China, The Significance of Juneteenth From a Fashion Perspective
    ## 85                                                                           Nile Rodgers, Chic, Darius Rucker to Perform at Juneteenth Unityfest
    ## 86                                                                                   President Biden Signs Bill Making Juneteenth Federal Holiday
    ## 87                                                               This Juneteenth NFT Fundraiser and Gallery Will Spotlight Global Black Creatives
    ## 88  The Value Gap: â\200\230None of us are free until weâ\200\231re all freeâ\200\231: Opal Lee, 94, has campaigned for years to make Juneteenth a national holiday
    ## 89                                                                               Juneteenth is finally a US national holidayâ\200”several years late
    ## 90                                                                        Apple Pay encourages users to shop Black-owned businesses on Juneteenth
    ## 91                                                                                   US Congress votes to make â\200\230Juneteenthâ\200\231 a federal holiday
    ## 92                                                                     Ibram X. Kendi on anti-racism, Juneteenth, and the reckoning that wasnâ\200\231t
    ## 93                                                                                     Weekly Watchlist: Biden Makes Juneteenth a Federal Holiday
    ## 94                                               'This is a day of profound weight': Biden signs law establishing Juneteenth as a federal holiday
    ## 95                                                                                                      U.S. to make Juneteenth a federal holiday
    ## 96                                                                                                          Facebook Details Its Juneteenth Plans
    ## 97                                                                  Congress passes bill to make Juneteenth, Emancipation Day, a national holiday
    ## 98                                                                                                            Celebrating Juneteenth in Galveston
    ## 99                                                                              AMC Entertainment Sets Showcase Of Black-Led Films For Juneteenth
    ## 100                                                                             Songs For Freedom: A Juneteenth Playlist From Pianist Lara Downes
    ##                                                                                                                                                                                                                                                                            description
    ## 1                                                                                                                                              June 19 is â\200œalso known as Macklemoreâ\200\231s birthday, but havenâ\200\231t Black Americans suffered enough?â\200\235 Colbert joked on Thursday night.
    ## 2                                                                                                                                                                                                                                Hereâ\200\231s what you need to know at the end of the day.
    ## 3                                                                                                                                      For contestants, itâ\200\231s a pageant, yes, but also a place to celebrate Black sisterhood and promote a deeper understanding of a complex holiday.
    ## 4                                                                                Academics believe that increases in the number of Americans familiar with the holiday, which commemorates the end of slavery in the U.S., may be a result of last summerâ\200\231s protests against racism.
    ## 5                                                                                                                                          The measure would designate June 19 as a federal holiday to commemorate the end of slavery. More than a dozen Republicans voted against it.
    ## 6                                                                                                                                                                        The law went into effect immediately, making Friday the first federal Juneteenth holiday in American history.
    ## 7                                                                                                                                       On Saturday, many of the cityâ\200\231s cultural venues are holding performances and parties to mark the emancipation of enslaved African Americans.
    ## 8                                                                                                  Some objected to the phrase â\200œIndependence Dayâ\200\235 in the formal name of the holiday celebrating the end of slavery. Others said federal workers did not need another paid day off.
    ## 9                                                                                                                                                                                     The commemoration of the last enslaved black American being freed is now an official US holiday.
    ## 10                                                                                                               Mayor Bill de Blasio vowed last year that Juneteenth would be an official holiday. City workers learned this week they would not be getting a paid day off after all.
    ## 11                                                              As the Senate passes Juneteenth National Independence Day Act, corporations including Best Buy and National Grid join a growing list of businesses who've recognized the occasion in the wake of George Floyd's death.
    ## 12                                                                                                  JPMorgan Chase & Co (JPM.N) will give its U.S. employees one floating day off for the newly implemented Juneteenth federal holiday, according to an internal memo seen by Reuters.
    ## 13                                                                                                                           U.S. President Joe Biden signed a bill into law on Thursday, making June 19 a federal holiday commemorating the emancipation of enslaved Black Americans.
    ## 14                                                                                                       U.S. President Joe Biden will sign a bill into law on Thursday afternoon to make June 19 a federal holiday commemorating the end of the legal enslavement of Black Americans.
    ## 15                                                                 The U.S. Centers for Disease Control and Prevention (CDC) on Thursday put off its meeting to discuss the occurrence of myocarditis among people who received COVID-19 shots due to the Juneteenth national holiday.
    ## 16                                                                                               The U.S. Securities and Exchange Commission (SEC) will close its offices on Friday in observance of the newly implemented Juneteenth federal holiday, the agency said in a statement.
    ## 17                                                        The U.S. House of Representatives on Wednesday overwhelmingly passed and sent to President Joe Biden a bill making June 19, or "Juneteenth," a federal holiday commemorating the end of legal enslavement ofBlack Americans.
    ## 18                                                                                               The U.S. Securities and Exchange Commission (SEC) will close its offices on Friday in observance of the newly implemented Juneteenth federal holiday, the agency said in a statement.
    ## 19                                                                                                                                                                                                                                         The self-defeating opposition to Juneteenth
    ## 20              Outrage erupted when social media spotted advertisements for the Historic Latta Plantation's racist Juneteenth celebration. Removing the advertisements did not erase the terrible, racist language the plantation used to promote its white people worshipping eveâ\200¦
    ## 21        Bed-Stuyâ\200\231s BLK MKT Vintageâ\200”founded by Jannah Handy and Kiyanna Stewartâ\200”specializes in second-hand delights from magazines to buttons, but this Juneteenth T-shirt is one of their own, new products. Commemorating and celebrating the holiday (the anniversary of â\200¦
    ## 22             Meet the designers whose activism got companies to commemorate the end of slavery.\nIf you have the day off of work on June 18 or 19, you can thank a small collective of Black artists and creative professionals in the Bay Area who call themselves Hella Creativâ\200¦
    ## 23                                                                                                                                                                           Juneteenth is an annual celebration held on June 19 to commemorate the end of chattel slavery in America.
    ## 24                                                                                                                                                                   June 19, known as Juneteenth, marks the end of slavery in the US. It is the first new federal holiday in decades.
    ## 25                                                         Sandra Quince was named a diversity-and-inclusion coalition's first-ever CEO days before the anniversary of George Floyd's death and a month before Juneteenth 2021, and the symbolism and opportunity are not lost on her.
    ## 26                                                                                                                               "We can all finally celebrate. The whole country together," says the 94-year-old who has been working for years to make Juneteenth a federal holiday.
    ## 27                                                                                                                                       Trump said "nobody had heard of" the holiday, which commemorates the liberation of enslaved Black Americans, according to a forthcoming book.
    ## 28                                                                                                                                                                                                                                              There are events all across the state.
    ## 29                                                                                                          JPMorgan Chase & Co will give its U.S. employees one floating day off for the newly implemented Juneteenth federal holiday, according to an internal memo seen by Reuters.
    ## 30  <ol><li>Juneteenth: US will soon have new holiday commemorating end of slaveryÂ Â CTV News\r\n</li><li>Juneteenth: US to add federal holiday marking end of slaveryÂ Â BBC News\r\n</li><li>Congress passes bill making Juneteenth a federal holidayÂ Â CNN \r\n</li><li>Juan Wâ\200¦
    ## 31                                                                                                                                                                                                                                    Juneteenth may finally get its due from Congress
    ## 32  <ol><li>Biden to sign bill making Juneteenth a U.S. federal holidayÂ Â Global News\r\n</li><li>Juneteenth: US to add federal holiday marking end of slaveryÂ Â BBC News\r\n</li><li>House passes bill to make Juneteenth a federal holidayÂ Â Washington Post\r\n</li><li>I donâ\200¦
    ## 33                                                                                                                                                                                  Here's how to make Juneteenth a celebration and a day of learning about our nation's true history.
    ## 34                                                                                               The United States government is catching up with Black people who have been commemorating the end of slavery in the United States for generations with a day called â\200œJuneteenth.â\200\235
    ## 35                                                                                                                                                           The Senate has passed a bill that would make Juneteenth, or June 19th, a federal holiday commemorating the end of slavery
    ## 36                                                                                               The recent effort to make the anniversary a federal holiday is undermined by the simultaneous attack on critical race theory and curricula focused on the enduring legacy of slavery.
    ## 37                                                                                                                 Congress has moved to establish a new national holiday, this time for Juneteenth. It's the first federal holiday approved since Martin Luther King Jr. Day in 1983.
    ## 38                                                                                                                       Late summer at West Point is stiflingly hot. But, as a brand-new cadet standing nervously in military formation, I barely noticed. I was consumed with the...
    ## 39                                                                                                                         Cary joins other Triangle area municipalities in formally recognizing the holiday commemorating emancipation of enslaved African Americans in the United...
    ## 40                                                                                                                                                           Historic Latta Plantation in Huntersville has since taken down promotional material for the event. Hereâ\200\231s what it said.
    ## 41                                                                                                                                                                          The Republicans who voted against the Juneteenth holiday think it will 'create confusion' alongside July 4
    ## 42                                                                                                                                                                                         Nearly 3 in 10 U.S. adults say they know 'nothing at all' about Saturday's June 19 holiday.
    ## 43                                                                                                                                     â\200œThe outrage in the community is realâ\200\235 over Historic Latta Plantationâ\200\231s planned event, Mecklenburg County Commissioner Mark Jerrell said.
    ## 44                                                                                                                                         The Historic Latta Plantation site manager called out Charlotte Mayor Vi Lyles as well as the media over controversy about the racist promo
    ## 45                                                                                                                                                                                                         Juneteenthâ\200\231s government recognition needs to come along with real action.
    ## 46                                                                                                                                                                                                   "Iâ\200\231m humbled by it, I truly am," said the "Grandmother of Juneteenth" Opal Lee.
    ## 47              Tomorrow is Juneteenth, commemorating the freeing of enslaved Black people in Texas on June 19, 1865. That was the day that Maj. Gen. Gordon Granger delivered a message to the people of Galveston, Texas that the Union had won the Civil War and they could enfoâ\200¦
    ## 48                                                                                                                    President Biden signed the Juneteenth National Independence Day Act into law on Thursday, commemorating the end of slavery in the U.S., and making June 19 a ...
    ## 49                                                                                                                                                                     Jimmy Fallon and Stephen Colbert cheer the new Juneteenth holiday, jeer the 14 congressmen who voted against it
    ## 50                                                                                                                                                                                               It's part of a plot to take over the country with Critical Race Theory, or something.
    ## 51              The commemoration marks when news of the Emancipation Proclamation reached Texas on 19 June 1865, ending slaveryThe United States will soon have a new federal holiday commemorating the end of slavery in the nation.Congress has approved a bill that would make â\200¦
    ## 52                                                                                                                               President Biden will sign the bill to make Juneteenth a federal holiday, the U.S. Open tees off at Torrey Pines and more news to start your Thursday.
    ## 53                                                                                                                               Enslaved people in Native American territories waited later for freedom. And Black Codes after the Civil War stalled much of emancipation's progress.
    ## 54                                                                                                                                       The House will vote on legislation Wednesday to make Juneteenth a federal holidayÂ â\200” just one day afterÂ the Senate passed the legislation.
    ## 55                                                                                                                                                                        President Joe Biden is signing a bill to make Juneteenth a federal holiday commemorating the end of slavery.
    ## 56                                                                                                                                                         "It's always been a very important holiday," says Tina Knowles-Lawson about Juneteenth. "Everyone needs to know the truth."
    ## 57              This year marks the 156th commemoration of Juneteenth. The holiday has largely been celebrated in Texas and certain pockets throughout the American South, but in recent years, people across America and even around the world have taken an interest in what Juneâ\200¦
    ## 58            Thereâ\200\231s nothing on Earth that gets stolen from more than Black culture. From our bodies being taken from Africa to every part of our identities being appropriated and fawned over, as infuriating as it may be, it makes sense that America would want to steal ouâ\200¦
    ## 59                                                                                                                    â\200œI, like many others, didnâ\200\231t even know anything about Juneteenth until I was an adult,â\200\235 Chicago Mayor Lori Lightfoot said Monday to kick off Juneteenth...
    ## 60                                                                                                              Thank you kindly for the â\200œrecognition,â\200\235 making Juneteenth a federal holiday, the literal least you could do â\200” coming some 150-plus years after weâ\200\231d already...
    ## 61                                                                                                                                                                                                                                   It's refreshing, tangy, and sweet. \nREAD MORE...
    ## 62                                                                                                                 WINSTON-SALEM, N.C. (AP) â\200” Officials in North Carolina have denounced plans â\200” now canceled â\200” by a historic museum to put on a reenactment of a white slave...
    ## 63                                                                                       As conservatives seek to ban critical race theory from schools, many Black Americans wonder if children will fully understand the new holiday marking the end of slavery.View Entire Post â\200º
    ## 64                                                                                                                                                                                          The site will donate 100% of its share of sales to the NAACP Legal Defense Fund on June 18
    ## 65                                                                                                                                  The common story of June 19 focuses on one white man. If you ask Black people, Juneteenth marks the day Black Americans created their own freedom.
    ## 66              The US will officially recognize Juneteenth as a federal holiday on 19 June after Joe Biden signed a bill into law which commemorates the end of slavery in the country. The president described a day to remember the moral stain of slavery but also to celebrateâ\200¦
    ## 67                                                                                                                                                                                                      Singer Macy Gray says the flag should be redesigned to represent all Americans
    ## 68                                                                                                                                                                                   Missouri, federal and Kansas City offices will be closed Friday in observance of the new holiday.
    ## 69                                                                                                                       Juneteenth is the recognition and celebration of Black liberation in the U.S. The reclamation of the day, for many Black Americans, makes note of both the...
    ## 70                                                                                                                                                                                         It features three of his favorite things: peaches, iced tea, and pound cake. \nREAD MORE...
    ## 71                                                                                                                           Celebrate Juneteenth with a free virtual event June 15 from 6 to 7 p.m., during which L.A. chefs and restaurateurs will talk about the holiday's Black...
    ## 72                                                                                                                    Exclusive: How will Washington quell the disdain in the Black community over Juneteenth becoming a federal holiday when voting rights and police reform bills...
    ## 73                                                                                                                                                                                                                                    Black L.A. reflects on first Juneteenth memories
    ## 74                                                                                                                                                                                      Are you tired of dealing with a perpetual loop of Zoom meetings and Wi-Fi connectivity issues?
    ## 75                                                                                                                                                                                                                                     Great for the grill or the oven. \nREAD MORE...
    ## 76                                                                                               As Washington policymakers establish June 19, known as Juneteenth, as a new federal holiday, the U.S. Office of Personnel Management said most federal employees will get Friday off.
    ## 77              June 19 is Juneteenth; a celebration of the emancipation of the last slaves in the US. This holiday deserves all the recognition.Last year Adafruit added Juneteenth as an official holiday for all Adafruit employees. Since it falls on a Saturday this year, theâ\200¦
    ## 78              EA's multiplayer dodgeball-battler Knockout City is getting a batch of Juneteenth related player icons later this week in its in-game shop. The icons will be free for all players.Juneteenth is celebrated on June 19 every year, and is the date used to mark theâ\200¦
    ## 79                                                                                                                                                              June 19th or Juneteenth is commemorated by many Black Americans as an independence day celebrating the end of slavery.
    ## 80              NYPL has published a great list of ways to celebrate Juneteenth, including events like the Schomburg Center Literary Festivals Reading the African Diaspora and Words Like Freedom, Juneteenth: The Lot Radio at the Library for the Performing Arts and more, and â\200¦
    ## 81        WASHINGTONâ\200”In a rare unanimous vote, the Senate passed a bill Wednesday to make Juneteenth a federal holiday so long as no one thinks too hard about its significance. â\200œThis is a day to barbecue and get drunk, a day to ask your coworkers what theyâ\200\231re planning â\200¦
    ## 82                                                                                                                                                              No lawmaker objected to passage of the legislation for commemorating the end of slavery, and it now goes to the House.
    ## 83                               President Biden has signed the Juneteenth National Independence Day Act, making June 19 a federal holiday to commemorate the day in 1865 when the last enslaved African Americans in Texas were granted their freedom. What do you think?Read more...
    ## 84             These are the stories making headlines in fashion on Wednesday. Dolce & Gabbana is still not welcome in ChinaÂ Hong Kong singer Karen Mok came under fire for wearing multiple Dolce & Gabbana pieces in her new music video. According to Business of Fashion, Mok â\200¦
    ## 85                                                                                                                                                                                                        Earth, Wind & Fire, Black Pumas, Khruangbin also in lineup for virtual event
    ## 86                             President Biden just made it official ... there's now a federal holiday marking a milestone in the abolishment of slavery in the United States. Biden put pen to paper Thursday, signing a landmark bill establishing June 19 as Juneteenth Nationalâ\200¦
    ## 87          17-year-old prodigious artist and activist Diana Sinclair is commemorating Juneteenth â\200” the annual holiday celebrating the end of slavery in the United States â\200” with the curation of an art exhibition, public installation and NFT auction fundraiser in New Yorkâ\200¦
    ## 88                                                                                                                                             â\200\230Iâ\200\231m wanting Juneteenth to be celebrated from the 19th of June to the Fourth of July. We werenâ\200\231t free the Fourth of July 1776.â\200\231
    ## 89                                                                                                                                                   Emancipation Day, also marking the end of slavery, already exists as a holiday in Canada and South Africa, among other countries.
    ## 90     What you need to know\n\n\nApple is encouraging Apple Pay users to shop Black-owned businesses on Juneteenth.\nThe company has highlighted a number of businesses for customers to shop.\n\n\nThis Juneteenth, shop Black-owned businesses. With Apple Pay.\n\nApple is encoâ\200¦
    ## 91                                                                                                                                                                 Congress sends bill to President Biden making June 19 a federal holiday commemorating the end of slavery in the US.
    ## 92                                                                                                                                                                                            The author of How to Be an Antiracist joined for a special episode of Vox Conversations.
    ## 93                                                                    Greetings, QuickTake readers! This week, Biden creates the first new national holiday since Martin Luther King Jr. Day. Plus: China gets one step closer to building its own space station. Stream now for free.
    ## 94                                                                                                                                                    Biden said that he hopes by establishing the holiday, "all Americans can feel the power of this day and learn from our history."
    ## 95                                                                            The United States will soon have a new federal holiday commemorating the end of slavery.The House voted 415-14 on Wednesday to make Juneteenth, or June 19th, the 12th federal holiday, and President Jo
    ## 96              Businesswoman and fashion designer Tina Knowles-Lawson is helping Facebook celebrate Juneteenth (Saturday, June 19) with a video detailing her family's deep connection with the holiday, their Texas roots, family memories and the beauty of how Black Americans â\200¦
    ## 97              President Joe Biden is expected to sign a bill into law Thursday to make Juneteenth, the commemoration of the end of U.S. slavery, a federal holiday. The legislation, officially named The Juneteenth National Independence Day Act, was approved by the House of â\200¦
    ## 98             The long-held myth goes that on June 19, 1865, Union genÂ­eral Gordon Granger stood on the balcony of Ashton Villa in Galveston, Texas, and read the order that announced the end of slavery. Though no contemporaneous evidence exists to specifically support the â\200¦
    ## 99              AMC Entertainment will present a weeklong AMC Black Picture Showcase at select theaters nationwide starting Friday to celebrate Juneteenth. The newly established national holiday commemorates the abolishment of slavery in the U.S. The exhibitor said tickets wâ\200¦
    ## 100                                                                                                                                                               Music offers freedom. Freedom of expression â\200” a way to rejoice and to mourn, to offer comfort, to call for change.
    ##                                                                                                                                                                                      url
    ## 1                                                                                                     https://www.nytimes.com/2021/06/18/arts/television/stephen-colbert-juneteenth.html
    ## 2                                                                                                    https://www.nytimes.com/2021/06/17/briefing/obamacare-juneteenth-supreme-court.html
    ## 3                                                                                                                      https://www.nytimes.com/2021/06/14/style/juneteenth-pageants.html
    ## 4                                                                                                                 https://www.nytimes.com/2021/06/16/us/politics/juneteenth-holiday.html
    ## 5                                                                                                         https://www.nytimes.com/2021/06/16/us/politics/juneteenth-federal-holiday.html
    ## 6                                                                                                           https://www.nytimes.com/2021/06/17/us/politics/juneteenth-holiday-biden.html
    ## 7                                                                                                          https://www.nytimes.com/2021/06/17/arts/music/juneteenth-new-york-events.html
    ## 8                                                                                                              https://www.nytimes.com/2021/06/17/us/republicans-against-juneteenth.html
    ## 9                                                                                                                                    https://www.bbc.co.uk/news/world-us-canada-57515192
    ## 10                                                                                               https://www.nytimes.com/2021/06/17/nyregion/juneteenth-not-a-holiday-nyc-employees.html
    ## 11                                                                                                                                           https://www.entrepreneur.com/article/374747
    ## 12                                                                          https://www.reuters.com/business/finance/jpmorgan-ubs-allow-us-employees-take-day-off-juneteenth-2021-06-17/
    ## 13                                                                                            https://www.reuters.com/world/us/what-is-juneteenth-how-are-people-marking-day-2021-06-18/
    ## 14                                                                      https://www.reuters.com/world/us/biden-sign-juneteenth-bill-creating-holiday-marking-us-slaverys-end-2021-06-17/
    ## 15                                                                                                                      https://www.reuters.com/article/usa-cdc-juneteenth-idUSL3N2NZ4JX
    ## 16                                                                   https://www.reuters.com/business/us-sec-close-its-offices-friday-observe-new-juneteenth-federal-holiday-2021-06-17/
    ## 17                                                                          https://www.reuters.com/world/us/us-congress-votes-create-juneteenth-holiday-marking-end-slavery-2021-06-16/
    ## 18                                                                                                                      https://www.reuters.com/article/us-usa-sec-holiday-idUSKCN2DT2N9
    ## 19                                                                                                            https://news.yahoo.com/self-defeating-opposition-juneteenth-214610235.html
    ## 20                                                                   https://boingboing.net/2021/06/12/plantation-removes-racist-juneteenth-celebration-advertisement-cancels-event.html
    ## 21                                                                                                                                        http://coolhunting.com/buy/juneteenth-t-shirt/
    ## 22                                                                                     https://www.fastcompany.com/90648158/how-14-black-creatives-got-800-companies-to-honor-juneteenth
    ## 23                                                                      https://www.npr.org/2021/06/15/1006934154/senate-unanimously-approves-a-bill-to-make-juneteenth-a-public-holiday
    ## 24                                                                           https://www.businessinsider.com/juneteenth-federal-holiday-biden-signs-bill-employees-get-friday-off-2021-6
    ## 25                                                                                                                                           https://www.entrepreneur.com/article/374765
    ## 26                                                                                                      https://www.npr.org/2021/06/17/1007498876/how-juneteenth-became-national-holiday
    ## 27                                                                                                          https://www.businessinsider.com/trump-claim-he-made-juneteenth-famous-2021-6
    ## 28                                                                                                             https://news.yahoo.com/juneteenth-2021-list-weekend-events-160806466.html
    ## 29                                                                                                             https://www.reuters.com/article/jpmorgan-holiday-juneteenth-idUSL3N2O02DC
    ## 30                                                                       https://www.ctvnews.ca/world/u-s-president-joe-biden-to-sign-bill-making-juneteenth-a-federal-holiday-1.5474068
    ## 31                                                                                                             https://news.yahoo.com/juneteenth-may-finally-due-congress-203837258.html
    ## 32                                                                                                           https://globalnews.ca/news/7957685/joe-biden-juneteenth-federal-holiday-us/
    ## 33                                                                                                    https://www.huffpost.com/entry/what-to-do-on-juneteenth_l_60c7c67be4b02df18f7f60da
    ## 34                                                                                        https://abcnews.go.com/Lifestyle/wireStory/explainer-story-juneteenth-federal-holiday-78338317
    ## 35                                                                               https://abcnews.go.com/Politics/wireStory/senate-approves-bill-make-juneteenth-federal-holiday-78303127
    ## 36                                                                                   https://www.theatlantic.com/culture/archive/2021/06/what-push-celebrate-juneteenth-conceals/619246/
    ## 37                                                                         https://abcnews.go.com/Politics/congress-passes-legislation-make-juneteenth-federal-holiday/story?id=78324593
    ## 38                                                                                                                   https://news.yahoo.com/juneteenth-erase-robert-e-lee-184119919.html
    ## 39                                                                                                              https://news.yahoo.com/town-cary-approves-juneteenth-paid-115933175.html
    ## 40                                                                                                            https://news.yahoo.com/nc-plantation-calls-slaveowner-white-180941656.html
    ## 41                                                                                                    https://news.yahoo.com/republicans-voted-against-juneteenth-holiday-153430744.html
    ## 42                                                                                                                      https://www.marketwatch.com/story/what-is-juneteenth-11623865187
    ## 43                                                                                                          https://news.yahoo.com/mecklenburg-end-contract-nc-plantation-010702465.html
    ## 44                                                                                                                  https://news.yahoo.com/nc-plantation-no-apology-slams-195640833.html
    ## 45                                                                                      https://slate.com/news-and-politics/2021/06/juneteenth-federal-holiday-recognition-symbolic.html
    ## 46                                                                                             https://www.huffpost.com/entry/juneteenth-opal-lee-celebration_n_60cc5f7de4b0876cc93c49af
    ## 47                                                             https://boingboing.net/2021/06/18/juneteenth-emancipation-is-a-marker-of-progress-for-white-americans-not-black-ones.html
    ## 48                                                                                                           https://news.yahoo.com/biden-signing-juneteenth-holiday-bill-204417113.html
    ## 49                                                                                                              https://news.yahoo.com/jimmy-fallon-stephen-colbert-cheer-084315450.html
    ## 50                                                                         https://www.vice.com/en/article/y3dbww/republicans-worst-excuses-for-not-wanting-a-juneteenth-federal-holiday
    ## 51                                                                                                   https://amp.theguardian.com/us-news/2021/jun/16/us-juneteenth-federal-holiday-biden
    ## 52                                                                 https://www.usatoday.com/story/news/2021/06/17/biden-signs-juneteenth-bill-us-open-5-things-know-thursday/7717100002/
    ## 53  https://www.usatoday.com/restricted/?return=https%3A%2F%2Fwww.usatoday.com%2Fstory%2Fnews%2Fnation%2F2021%2F06%2F18%2Fjuneteenth-slavery-freedom-delayed-celebration%2F7713722002%2F
    ## 54                                                           https://www.usatoday.com/story/news/politics/2021/06/16/juneteenth-house-vote-bill-make-june-19-federal-holiday/7713301002/
    ## 55                                                                              https://abcnews.go.com/Politics/biden-signs-bill-making-juneteenth-marking-end-slavery/story?id=78335485
    ## 56                                                https://www.usatoday.com/story/entertainment/celebrities/2021/06/18/juneteenth-federal-holiday-celebrities-react-celebrate/7726515002/
    ## 57                                                                                                                         https://food52.com/blog/26293-juneteenth-virtual-potluck-2021
    ## 58                                                                                                   https://deadspin.com/juneteenth-is-being-hijacked-from-african-americans-1847130068
    ## 59                                                                                                          https://news.yahoo.com/chicago-mayor-changes-course-announces-233100704.html
    ## 60                                                                                                            https://news.yahoo.com/vine-juneteenth-m-thankful-hypocrisy-181044610.html
    ## 61                                                                                                                                 https://www.thekitchn.com/watermelon-limeade-23173384
    ## 62                                                                                                       https://news.yahoo.com/play-lamenting-confederacy-north-carolina-223157736.html
    ## 63                                                                                 https://www.buzzfeednews.com/article/tasneemnashrulla/juneteenth-federal-holiday-critical-race-theory
    ## 64                                                                                                    https://pitchfork.com/news/bandcamp-announces-second-annual-juneteenth-fundraiser/
    ## 65                                                                                                                                         https://time.com/6073043/who-made-juneteenth/
    ## 66                                     https://www.theguardian.com/world/video/2021/jun/17/biden-signs-bill-marking-juneteenth-as-federal-holiday-celebrating-end-of-slavery-in-us-video
    ## 67                                                                                                  https://www.marketwatch.com/story/for-juneteenth-its-time-for-a-new-flag-11623958522
    ## 68                                                                                                           https://news.yahoo.com/juneteenth-now-federal-holiday-closed-000020197.html
    ## 69                                           https://news.yahoo.com/american-celebrations-of-juneteenth-continue-to-multiply-158-years-following-the-abolition-of-slavery-184206410.html
    ## 70                                                                                                           https://www.thekitchn.com/peach-iced-tea-pound-cake-trifles-recipe-23169475
    ## 71                                                                                                              https://news.yahoo.com/red-drinks-juneteenth-free-virtual-202433794.html
    ## 72                                                                                                               https://news.yahoo.com/biden-signs-law-making-juneteenth-200500703.html
    ## 73                                                                                                               https://news.yahoo.com/never-forget-first-juneteenth-let-233840408.html
    ## 74                                                                                                        https://news.yahoo.com/juneteenth-now-federal-holiday-celebrate-110311445.html
    ## 75                                                                                                                https://www.thekitchn.com/kansas-city-style-bbq-chicken-wings-23173382
    ## 76                                                                               https://www.marketwatch.com/story/when-does-the-juneteenth-holiday-go-into-effect-right-now-11623958808
    ## 77                                                                                     https://blog.adafruit.com/2021/06/15/adafruit-celebrates-juneteenth-2021-juneteenth-emancipation/
    ## 78                                                                                  https://www.gamespot.com/articles/knockout-city-adding-free-juneteenth-items-this-week/1100-6492928/
    ## 79                                                                                   https://www.insider.com/north-carolina-plantation-cancels-juneteenth-event-on-white-refugees-2021-6
    ## 80                                                                                                                              https://blog.adafruit.com/2021/06/16/juneteenth-at-nypl/
    ## 81                                                                                           https://www.theonion.com/senate-votes-to-make-juneteenth-federal-holiday-so-long-1847111858
    ## 82                                                                                                 https://www.politico.com/news/2021/06/15/senate-passes-juneteenth-bill-holiday-494707
    ## 83                                                                                                                https://www.theonion.com/juneteenth-becomes-federal-holiday-1847123153
    ## 84                                                                                                               https://fashionista.com/2021/06/dolce-gabbana-karen-mok-china-criticism
    ## 85                                                                                         https://www.rollingstone.com/music/music-news/nile-rodgers-chic-juneteenth-unityfest-1181815/
    ## 86                                                                                          https://www.tmz.com/2021/06/17/president-biden-signs-bill-making-juneteenth-federal-holiday/
    ## 87                                                                                                       https://hypebeast.com/2021/6/juneteenth-nft-fundraiser-gallery-digital-diaspora
    ## 88                      https://www.marketwatch.com/story/none-of-us-are-free-until-were-all-free-opal-lee-94-has-campaigned-for-years-to-make-juneteenth-a-national-holiday-11623941587
    ## 89                                                                                                https://qz.com/2022128/juneteenth-is-finally-a-us-national-holiday-several-years-late/
    ## 90                                                                                               https://www.imore.com/apple-pay-encourages-users-shop-black-owned-businesses-juneteenth
    ## 91                                                                                          https://www.aljazeera.com/news/2021/6/16/us-congress-votes-to-make-juneteeth-federal-holiday
    ## 92                                                                                                     https://www.vox.com/22538592/ibram-x-kendi-juneteenth-racial-reckoning-antiracism
    ## 93                                                                       https://www.bloomberg.com/news/newsletters/2021-06-17/weekly-watchlist-biden-makes-juneteenth-a-federal-holiday
    ## 94                                                                          https://www.politico.com/news/2021/06/17/biden-signs-law-establishing-juneteenth-as-a-federal-holiday-495064
    ## 95                                                                               https://www.thehindu.com/news/international/us-to-make-juneteenth-a-federal-holiday/article34843172.ece
    ## 96                                                                                                                   https://www.adweek.com/media/facebook-details-its-juneteenth-plans/
    ## 97                                                                                                        http://thepointsguy.com/news/congress-passes-bill-juneteenth-national-holiday/
    ## 98                                                                                                   https://www.theparisreview.org/blog/2021/06/18/celebrating-juneteenth-in-galveston/
    ## 99                                                                                     https://deadline.com/2021/06/amc-entertainment-juneteenth-showcase-do-the-right-thing-1234776436/
    ## 100                                                      https://www.npr.org/sections/pictureshow/2021/06/18/1007389777/songs-for-freedom-a-juneteenth-playlist-from-pianist-lara-downes
    ##                                                                                                                                                                                                                                                                                                                        urlToImage
    ## 1                                                                                                                                                                                                                                       https://static01.nyt.com/images/2021/06/18/arts/18latenight/18latenight-facebookJumbo.png
    ## 2                                                                                                                                                                      https://static01.nyt.com/images/2021/06/17/multimedia/17PMBriefing-SCOTUS-01-promo/merlin_188742447_54de205d-1244-4797-b5ba-068ac1859f3d-facebookJumbo.jpg
    ## 3                                                                                                                                                                                                                     https://static01.nyt.com/images/2021/06/17/multimedia/15missjuneteenth4/15missjuneteenth4-facebookJumbo.jpg
    ## 4                                                                                                                                                                                           https://static01.nyt.com/images/2021/06/15/us/15xp-juneteenth/merlin_187353909_f7d2f12c-4108-4ad0-b647-dfb69349bf04-facebookJumbo.jpg
    ## 5                                                                                                                                                                                                                        https://static01.nyt.com/images/2021/06/16/us/politics/16dc-juneteenth/16dc-juneteenth-facebookJumbo.jpg
    ## 6                                                                                                                                                                                https://static01.nyt.com/images/2021/06/17/multimedia/17dc-Juneteenth-01/merlin_189428856_b346e5c0-852d-400f-bf8b-9b652307dba0-facebookJumbo.jpg
    ## 7                                                                                                                                                                                  https://static01.nyt.com/images/2021/06/16/arts/16juneteenth-roundup-2/merlin_189341973_15ee7212-2beb-432e-b935-fd347ed06881-facebookJumbo.jpg
    ## 8                                                                                                                                                                                                             https://static01.nyt.com/images/2021/06/17/multimedia/17xp-juneteeenth-vote/17xp-juneteeenth-vote-facebookJumbo.jpg
    ## 9                                                                                                                                                                                                                                        https://ichef.bbci.co.uk/news/1024/branded_news/1148C/production/_118969707_untitled.png
    ## 10                                                                                                                                                                                                                            https://static01.nyt.com/images/2021/06/17/nyregion/17nyjuneteenth/17nyjuneteenth-facebookJumbo.jpg
    ## 11                                                                                                                                                                                                                                         https://assets.entrepreneur.com/content/3x2/2000/1623857245-GettyImages-1320637700.jpg
    ## 12                                                                                                                                            https://www.reuters.com/resizer/3PC6doH3UXWta_Kq7JE0bCkOxp0=/800x419/smart/filters:quality(80)/cloudfront-us-east-2.images.arcpublishing.com/reuters/KYGVOATU4RKLBAUZ5ZZTP244EE.jpg
    ## 13                                                                                                                                            https://www.reuters.com/resizer/f5b_CxET2cMlvVEMUVCupa5GD4U=/800x419/smart/filters:quality(80)/cloudfront-us-east-2.images.arcpublishing.com/reuters/O5SIXYUUTZKKFN5SOJ7SW5SC4U.jpg
    ## 14                                                                                                                                            https://www.reuters.com/resizer/9sJClrqOF9uWxsf5afHDwDKsNS0=/800x419/smart/filters:quality(80)/cloudfront-us-east-2.images.arcpublishing.com/reuters/SD7MOK2STVJCVL6O53Q6RKJW7Q.jpg
    ## 15                                                                                                                                                                                                                                                         https://s1.reutersmedia.net/resources_v2/images/rcom-default.png?w=800
    ## 16                                                                                                                                            https://www.reuters.com/resizer/MKKqopu8oFTPxYw98LkUcDOGew4=/800x419/smart/filters:quality(80)/cloudfront-us-east-2.images.arcpublishing.com/reuters/IOQW7HRU6VPY7PUF65C767WK2Q.jpg
    ## 17                                                                                                                                            https://www.reuters.com/resizer/xOEHsQbMhXa3lNseuul5aKQA3ZQ=/800x419/smart/filters:quality(80)/cloudfront-us-east-2.images.arcpublishing.com/reuters/3PRC3KNX3JL5RAXD62THL4CUMU.jpg
    ## 18                                                                                                                                                                                                                                 https://static.reuters.com/resources/r/?m=02&d=20210617&t=2&i=1566090243&r=LYNXNPEH5G1EK&w=800
    ## 19                                                                                                                                                     https://s.yimg.com/uu/api/res/1.2/x5LjPtfpdNYY3MdYl6ZqnQ--~B/aD0xNjk7dz0zMDA7YXBwaWQ9eXRhY2h5b24-/https://media.zenfs.com/en/the_week_574/704755152c3243af6ec50d9d5bbe6b23
    ## 20                                                                                                                                                                                                               https://i1.wp.com/boingboing.net/wp-content/uploads/2021/06/9HUOCBJ_latta_plantation_2.jpeg?fit=1140%2C641&ssl=1
    ## 21                                                                                                                                                                                                                          https://i0.wp.com/coolhunting.com/wp-content/uploads/2021/06/juneteenth-shirt.jpg?fit=720%2C720&ssl=1
    ## 22                                                                                                                                                              https://images.fastcompany.net/image/upload/w_1280,f_auto,q_auto,fl_lossy/wp-cms/uploads/2021/06/01-90648158-how-this-group-of-creatives-got-805-companies-to.jpg
    ## 23                                                                                                                                                                                                         https://media.npr.org/assets/img/2021/06/15/ap_21159743395750_wide-f522ef240cad791b700ab0e65d5a9bc4c52e0777.jpg?s=1400
    ## 24                                                                                                                                                                                                                                                          https://i.insider.com/60cbaf8920bd1300181c6fcd?width=1200&format=jpeg
    ## 25                                                                                                                                                                                                                                                https://assets.entrepreneur.com/content/3x2/2000/1623869599-SandraQheadshot.jpg
    ## 26                                                                                                                                                                                                          https://media.npr.org/assets/img/2021/06/17/ap21167848888802_wide-8b39ace8b08e36d02337a27f2a7da5255b392f78.jpg?s=1400
    ## 27                                                                                                                                                                                                                                                          https://i.insider.com/5f0ccfc33f7370403c78d455?width=1200&format=jpeg
    ## 28                                                                                                                                                                                                                                                     https://s.yimg.com/cv/apiv2/social/images/yahoo_default_logo-1200x1200.png
    ## 29                                                                                                                                                                                                                                                         https://s1.reutersmedia.net/resources_v2/images/rcom-default.png?w=800
    ## 30                                                                                                                                                                                                           https://www.ctvnews.ca/polopoly_fs/1.4991185.1592568167!/httpImage/image.jpg_gen/derivatives/landscape_620/image.jpg
    ## 31                                                                                                                                                     https://s.yimg.com/uu/api/res/1.2/UW2N5xjk8RC2YIEWBtEzHw--~B/aD0xNjk7dz0zMDA7YXBwaWQ9eXRhY2h5b24-/https://media.zenfs.com/en/the_week_574/c36df197e797bc61a7b487072e64d23a
    ## 32                                                                                                                                                                                                                       https://globalnews.ca/wp-content/uploads/2021/06/CP125227064.jpg?quality=85&strip=all&w=720&h=379&crop=1
    ## 33                                                                                                                                                                                                                               https://img.huffingtonpost.com/asset/60cb98d1410000081c812a9f.jpg?cache=HD8JfKuPVF&ops=1778_1000
    ## 34                                                                                                                                                                                                                                    https://s.abcnews.com/images/Lifestyle/WireAP_131cd902323d4b36bd0b4689bc05a671_16x9_992.jpg
    ## 35                                                                                                                                                                                                                                     https://s.abcnews.com/images/Politics/WireAP_7fb9a6f46f4e4b55b001fb25f6514029_16x9_992.jpg
    ## 36                                                                                                                         https://cdn.theatlantic.com/thumbor/qsdkR77bA05XgofnNTtBT4pvaSA=/0x397:7716x4416/960x500/media/img/mt/2021/06/2021_06_17T200812Z_1752682399_RC2K2O937TXB_RTRMADP_3_USA_BIDEN_JUNETEENTHbw/original.jpg
    ## 37                                                                                                                                                                                                                       https://s.abcnews.com/images/Politics/juneteenth-atlanta-gty-jc-210615_1623797667446_hpMain_16x9_992.jpg
    ## 38                                                                                                                                       https://s.yimg.com/uu/api/res/1.2/MUKFX041spqM91PRjsKpBA--~B/aD03NjA7dz0xMTQwO2FwcGlkPXl0YWNoeW9u/https://media.zenfs.com/en/miami_herald_mcclatchy_975/2cbeda4c879674777cfa92af659ce377
    ## 39                                                                                                                          https://s.yimg.com/uu/api/res/1.2/PhaXs_Txt9DZJNj6lunRSA--~B/aD03NjA7dz0xMTQwO2FwcGlkPXl0YWNoeW9u/https://media.zenfs.com/en/raleigh_news_and_observer_mcclatchy_712/d607330b580effe2e3afe845820b62a6
    ## 40                                                                                                                                 https://s.yimg.com/uu/api/res/1.2/OnfdNI7spj3V2MoFpCbmXw--~B/aD0zOTA7dz0xMTQwO2FwcGlkPXl0YWNoeW9u/https://media.zenfs.com/en/charlotte_observer_mcclatchy_513/46b883c6f028edea80c9966bd153844f
    ## 41                                                                                                                                                                                                                                                     https://s.yimg.com/cv/apiv2/social/images/yahoo_default_logo-1200x1200.png
    ## 42                                                                                                                                                                                                                                                                                       https://images.mktw.net/im-354965/social
    ## 43                                                                                                                          https://s.yimg.com/uu/api/res/1.2/XqjEt7w4Aztv6YK.ds.KIg--~B/aD0zOTA7dz0xMTQwO2FwcGlkPXl0YWNoeW9u/https://media.zenfs.com/en/raleigh_news_and_observer_mcclatchy_712/46b883c6f028edea80c9966bd153844f
    ## 44                                                                                                                          https://s.yimg.com/uu/api/res/1.2/qZzYPWTITymvNAcO_r5bkQ--~B/aD02MTM7dz0xMTQwO2FwcGlkPXl0YWNoeW9u/https://media.zenfs.com/en/raleigh_news_and_observer_mcclatchy_712/d9545d1a44c2a845aac7d6b69b3816d9
    ## 45                                                                                                                                                                                                      https://compote.slate.com/images/cfa2ed1f-a02c-4b51-8c20-00ead9451d63.jpeg?width=780&height=520&rect=6000x4000&offset=0x0
    ## 46                                                                                                                                                                                                                               https://img.huffingtonpost.com/asset/60cc65f53b0000ea19ec32c8.png?cache=dbykn0w0km&ops=1778_1000
    ## 47                                                                                                                                                                                                                             https://i0.wp.com/boingboing.net/wp-content/uploads/2021/06/screenshot-88.jpg?fit=1200%2C916&ssl=1
    ## 48                                                                                                                                                                                                 https://s.yimg.com/hd/cp-video-transcode/prod/2021-06/17/60cbb423d024e625dc93c0b1/60cbb42ebeaecd000137ac01_1280x720_FES_v1.jpg
    ## 49                                                                                                                                                                                                                                                     https://s.yimg.com/cv/apiv2/social/images/yahoo_default_logo-1200x1200.png
    ## 50                                                                                                                https://video-images.vice.com/articles/60cb551e398768009bef120a/lede/1623941070532-gettyimages-1233505126.jpeg?image-resize-opts=Y3JvcD0xeHc6MC44NDI3eGg7MHh3LDAuMTQxN3hoJnJlc2l6ZT0xMjAwOiomcmVzaXplPTEyMDA6Kg
    ## 51  https://i.guim.co.uk/img/media/2fc70c24274d6e35ab0cb84298d699719d757d15/0_269_4974_2984/master/4974.jpg?width=1200&height=630&quality=85&auto=format&fit=crop&overlay-align=bottom%2Cleft&overlay-width=100p&overlay-base64=L2ltZy9zdGF0aWMvb3ZlcmxheXMvdGctZGVmYXVsdC5wbmc&enable=upscale&s=0e5f9efa3ae16be45239e77add94d573
    ## 52                                                                                                                                                          https://www.gannett-cdn.com/presto/2021/06/16/USAT/a0b60bb8-9591-4769-890e-e639613ea390-Juneteenth_RectThumb.png?crop=1327,747,x0,y0&width=1600&height=800&fit=bounds
    ## 53                                                                                                                                                                                                                                                                                                                           <NA>
    ## 54                                                                                                                 https://www.gannett-cdn.com/-mm-/7ed20b304600a5bc3c1cde9d031080712de15386/c=0-92-2500-1498/local/-/media/2020/09/11/USATODAY/usatsports/ghows_gallery-WL-619009981-588df6d4.jpg?width=1600&height=800&fit=crop
    ## 55                                                                                                                                                                                                            https://s.abcnews.com/images/Politics/juneteenth-federal-holiday-04-ap-llr-210617_1623960681558_hpMain_16x9_992.jpg
    ## 56                                                                                                                                                             https://www.gannett-cdn.com/presto/2021/04/12/USAT/00875900-1cc1-4a0c-9d0c-7e03e21daa5e-GTY_1209986395.JPG?crop=2357,1326,x0,y100&width=1600&height=800&fit=bounds
    ## 57                                                                                                                                                                    https://images.food52.com/0uByYGMTq_qikYFtlDZU2xFYY_U=/fit-in/1200x1200/52166fa5-f041-49fc-bb53-56ba0e3b4967--Chene-e_Today_Lemon_Sour_Cream_Pound_Cake.jpg
    ## 58                                                                                                                                                                            https://i.kinja-img.com/gawker-media/image/upload/c_fill,f_auto,fl_progressive,g_center,h_675,pg_1,q_80,w_1200/24a0c760beb0fec77a8d3f7901a93139.jpg
    ## 59                                                                                                                                       https://s.yimg.com/uu/api/res/1.2/oRe1iY.Fmp7SAOsmNP.A.w--~B/aD02ODM7dz0xMDI0O2FwcGlkPXl0YWNoeW9u/https://media.zenfs.com/en/thegrio_yahoo_articles_946/f177e026a0b128ed904639cfe7a189f4
    ## 60                                                                                                                          https://s.yimg.com/uu/api/res/1.2/S8aWodE2bWY4Pmpngo14lg--~B/aD02NDE7dz0xMTQwO2FwcGlkPXl0YWNoeW9u/https://media.zenfs.com/en/kansas_city_star_mcclatchy_articles_677/dd58ab282e7490b10c580e04f54945f0
    ## 61                                                                                                                                                   https://cdn.apartmenttherapy.info/image/upload/f_auto,q_auto:eco,c_fill,g_auto,w_1500,ar_3:2/k%2FPhoto%2FRecipes%2F2021-06-juneteenth-cocktail%2FKitchn_Juneteenth_Recipes_4
    ## 62                                                                                                                                                                                                                                                     https://s.yimg.com/cv/apiv2/social/images/yahoo_default_logo-1200x1200.png
    ## 63                                                                                                                                      https://img.buzzfeed.com/buzzfeed-static/static/2021-06/16/23/campaign_images/6d8befc08e8f/congress-has-made-juneteenth-a-national-holiday-j-2-757-1623886510-17_dblbig.jpg?resize=1200:*
    ## 64                                                                                                                                                                                                                                   https://media.pitchfork.com/photos/5eff4056dc55f46b46324252/16:9/w_1280,c_limit/Bandcamp.jpg
    ## 65                                                                                                                                                                                                                         https://api.time.com/wp-content/uploads/2021/06/who-made-juneteenth.jpg?quality=85&w=1200&h=628&crop=1
    ## 66  https://i.guim.co.uk/img/media/86616d9db997660e2925a23fe89b8ad0f1c59746/0_238_5621_3373/master/5621.jpg?width=1200&height=630&quality=85&auto=format&fit=crop&overlay-align=bottom%2Cleft&overlay-width=100p&overlay-base64=L2ltZy9zdGF0aWMvb3ZlcmxheXMvdGctZGVmYXVsdC5wbmc&enable=upscale&s=5d2517eae1d52a7d38dc2930563fe67c
    ## 67                                                                                                                                                                                                                                                                                       https://images.mktw.net/im-355759/social
    ## 68                                                                                                                          https://s.yimg.com/uu/api/res/1.2/NrqVVmtt4dZfKH52fkXPvg--~B/aD03ODY7dz0xMTQwO2FwcGlkPXl0YWNoeW9u/https://media.zenfs.com/en/kansas_city_star_mcclatchy_articles_677/3ae99993ee91c3aba865f2dc2e3009d3
    ## 69                                                                                                                                                                                                                                      https://s.yimg.com/os/creatr-uploaded-images/2021-06/9b4df2a0-ce04-11eb-bf63-142cced07dd6
    ## 70                                                                                                                                                           https://cdn.apartmenttherapy.info/image/upload/f_auto,q_auto:eco,c_fill,g_auto,w_1500,ar_3:2/k%2FPhoto%2FRecipes%2F2021-sweet-peach-tea-trifle%2F2021-06-02_ATK-1324
    ## 71                                                                                                                                            https://s.yimg.com/uu/api/res/1.2/lHfu6OShZYfXzpTFBKWmSA--~B/aD01NjA7dz04NDA7YXBwaWQ9eXRhY2h5b24-/https://media.zenfs.com/en/la_times_articles_853/ca8ea4fcf559bc270dfbf958380721cb
    ## 72                                                                                                                                       https://s.yimg.com/uu/api/res/1.2/3TlEn7g.gPyQuiWM32XuQw--~B/aD01NzY7dz0xMDI0O2FwcGlkPXl0YWNoeW9u/https://media.zenfs.com/en/thegrio_yahoo_articles_946/b11a251a36bdcec788e803b5e921743a
    ## 73                                                                                                                                            https://s.yimg.com/uu/api/res/1.2/fVdxrO8Y5M1DEH1_4n6OMQ--~B/aD01NjA7dz04NDA7YXBwaWQ9eXRhY2h5b24-/https://media.zenfs.com/en/la_times_articles_853/f271aa9dc521a5d13283e52756e18ec0
    ## 74                                                                                                                                       https://s.yimg.com/uu/api/res/1.2/2mvyUhpNOG83mHd0YX15VQ--~B/aD03NjA7dz0xMTQwO2FwcGlkPXl0YWNoeW9u/https://media.zenfs.com/en/miami_herald_mcclatchy_975/38428c5e2458604f5a19cb3eed95be5c
    ## 75                                                                                                                                                      https://cdn.apartmenttherapy.info/image/upload/f_auto,q_auto:eco,c_fill,g_auto,w_1500,ar_3:2/k%2FPhoto%2FRecipes%2F2021-06-juneteenth-wings%2FKitchn_Juneteenth_Recipes_3
    ## 76                                                                                                                                                                                                                                                                                   https://images.mktw.net/im-355803/horizontal
    ## 77                                                                                                                                                                                                                                              https://cdn-blog.adafruit.com/uploads/2021/06/adafruit_juneteenth_2021_blog-2.jpg
    ## 78                                                                                                                                                                                                                             https://www.gamespot.com/a/uploads/screen_kubrick/1647/16470614/3844372-knockoutcityjuneteenth.jpg
    ## 79                                                                                                                                         https://s.yimg.com/uu/api/res/1.2/r2oeBIwgxM_8cDiZjEwM.A--~B/aD0xNTAwO3c9MjAwMDthcHBpZD15dGFjaHlvbg--/https://media.zenfs.com/en/insider_articles_922/36c96bbb4c751a6b7ba26488f32267b2
    ## 80                                                                                                                                                                                                                                                           https://cdn-blog.adafruit.com/uploads/2021/06/Juneteenth_Feature.png
    ## 81                                                                                                                                                                            https://i.kinja-img.com/gawker-media/image/upload/c_fill,f_auto,fl_progressive,g_center,h_675,pg_1,q_80,w_1200/069d98393ff04a3901cbd64df4a14cc2.jpg
    ## 82                                                                                                                                                                                                                                    https://static.politico.com/b7/a7/284f07ad4ee59d351e99444c5cdf/gettyimages-1232326298-1.jpg
    ## 83                                                                                                                                                                                        https://i.kinja-img.com/gawker-media/image/upload/c_fill,f_auto,fl_progressive,g_center,h_675,pg_1,q_80,w_1200/abwm6w3prjmdcyvoqfxn.jpg
    ## 84                                                                                                                                                                                                                                 https://fashionista.com/.image/t_share/MTgxNzc1OTg5NDUyMzE3ODI3/dolce-gabbana-china-issues.jpg
    ## 85                                                                                                                                                                                                                                                      https://www.rollingstone.com/wp-content/uploads/2021/06/nile-rodgersc.jpg
    ## 86                                                                                                                                                                                                                                       https://imagez.tmz.com/image/cd/16by9/2021/06/17/cd8d393219854d09bed817b31eea9d34_xl.jpg
    ## 87                                                                                                                                   https://image-cdn.hypb.st/https%3A%2F%2Fhypebeast.com%2Fimage%2F2021%2F06%2FThis-Juneteenth-NFT-Fundraiser-and-Gallery-Will-Spotlight-Global-Black-Creatives-TW.jpg?w=960&cbr=1&q=90&fit=max
    ## 88                                                                                                                                                                                                                                                                                       https://images.mktw.net/im-354925/social
    ## 89                                                                                                                                          https://cms.qz.com/wp-content/uploads/2021/06/2020-06-19T231642Z_740397157_RC2NCH9G52IJ_RTRMADP_3_MINNEAPOLIS-POLICE-JUNETEENTH-NEW-YORK.jpg?quality=75&strip=all&w=1200&h=630&crop=1
    ## 90                                                                                                                                                                                                              https://www.imore.com/sites/imore.com/files/styles/large/public/field/image/2021/06/apple-pay-juneteenth-2021.jpg
    ## 91                                                                                                                                                                                                                                  https://www.aljazeera.com/wp-content/uploads/2021/06/AP20205838533454-1.jpg?resize=1200%2C630
    ## 92                                                                                                                                                                 https://cdn.vox-cdn.com/thumbor/qToa8DorWMihPAc-RoNgR_NvwXY=/0x293:3287x2014/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/22665259/1175990285.jpg
    ## 93                                                                                                                                                                                                                                                  https://assets.bwbx.io/images/users/iqjWHBFdfxIU/ie64xe49Y8no/v0/1200x759.jpg
    ## 94                                                                                                                                                                                                                                        https://static.politico.com/d2/ab/6eab1e984661afb227e70da6be80/2106017-biden-ap-773.jpg
    ## 95                                                                                                                                                                                                                                                            https://www.thehindu.com/static/theme/default/base/img/og-image.jpg
    ## 96                                                                                                                                                                                                                                             https://www.adweek.com/wp-content/uploads/2021/06/FBJuneteenthWordmark-600x315.jpg
    ## 97                                                                                                                                                                                                                                https://thepointsguy.global.ssl.fastly.net/us/originals/2020/06/Denver_Joe-Amon-Contributor.jpg
    ## 98                                                                                                                                                                                                                                                https://www.theparisreview.org/blog/wp-content/uploads/2021/06/ashton-villa.jpg
    ## 99                                                                                                                                                                                                                                                  https://deadline.com/wp-content/uploads/2020/08/do-the-right-thing.jpg?w=1024
    ## 100                                                                                                                                                                                                     https://media.npr.org/assets/img/2021/06/16/juneteenthplaylist-1_wide-68f53fee5771fb3b268b913f94ddc06c4adb3fd3.jpg?s=1400
    ##              publishedAt
    ## 1   2021-06-18T05:36:41Z
    ## 2   2021-06-17T21:52:36Z
    ## 3   2021-06-15T16:51:21Z
    ## 4   2021-06-16T22:08:29Z
    ## 5   2021-06-16T23:41:48Z
    ## 6   2021-06-17T22:51:36Z
    ## 7   2021-06-18T08:29:10Z
    ## 8   2021-06-17T20:08:10Z
    ## 9   2021-06-17T20:15:15Z
    ## 10  2021-06-17T19:31:32Z
    ## 11  2021-06-16T15:27:51Z
    ## 12  2021-06-17T22:28:00Z
    ## 13  2021-06-18T00:16:00Z
    ## 14  2021-06-17T15:27:00Z
    ## 15  2021-06-17T21:58:00Z
    ## 16  2021-06-17T20:37:00Z
    ## 17  2021-06-16T23:54:00Z
    ## 18  2021-06-17T20:38:00Z
    ## 19  2021-06-17T21:46:10Z
    ## 20  2021-06-12T19:25:19Z
    ## 21  2021-06-15T17:05:05Z
    ## 22  2021-06-18T06:00:41Z
    ## 23  2021-06-15T22:21:21Z
    ## 24  2021-06-17T20:13:08Z
    ## 25  2021-06-17T14:35:00Z
    ## 26  2021-06-17T20:05:02Z
    ## 27  2021-06-18T16:12:25Z
    ## 28  2021-06-18T16:08:06Z
    ## 29  2021-06-18T09:16:00Z
    ## 30  2021-06-17T09:59:43Z
    ## 31  2021-06-15T20:38:37Z
    ## 32  2021-06-17T12:27:13Z
    ## 33  2021-06-17T22:54:18Z
    ## 34  2021-06-17T17:08:17Z
    ## 35  2021-06-16T12:22:33Z
    ## 36  2021-06-18T10:00:00Z
    ## 37  2021-06-16T23:37:51Z
    ## 38  2021-06-17T18:41:19Z
    ## 39  2021-06-10T11:59:33Z
    ## 40  2021-06-11T18:09:41Z
    ## 41  2021-06-18T15:34:30Z
    ## 42  2021-06-16T17:39:00Z
    ## 43  2021-06-16T01:07:02Z
    ## 44  2021-06-12T19:56:40Z
    ## 45  2021-06-17T19:29:50Z
    ## 46  2021-06-18T09:52:02Z
    ## 47  2021-06-18T16:09:38Z
    ## 48  2021-06-17T20:44:17Z
    ## 49  2021-06-18T08:43:15Z
    ## 50  2021-06-17T14:45:19Z
    ## 51  2021-06-17T01:24:41Z
    ## 52  2021-06-17T09:19:51Z
    ## 53  2021-06-18T12:01:16Z
    ## 54  2021-06-16T16:14:17Z
    ## 55  2021-06-17T20:21:08Z
    ## 56  2021-06-18T15:18:26Z
    ## 57  2021-06-17T13:00:00Z
    ## 58  2021-06-18T16:22:00Z
    ## 59  2021-06-15T23:31:00Z
    ## 60  2021-06-17T18:10:44Z
    ## 61  2021-06-16T14:16:06Z
    ## 62  2021-06-11T22:31:57Z
    ## 63  2021-06-16T23:37:09Z
    ## 64  2021-06-11T16:24:59Z
    ## 65  2021-06-16T14:10:24Z
    ## 66  2021-06-18T01:14:49Z
    ## 67  2021-06-17T19:35:00Z
    ## 68  2021-06-18T00:00:20Z
    ## 69  2021-06-15T18:42:06Z
    ## 70  2021-06-16T16:01:06Z
    ## 71  2021-06-14T20:24:33Z
    ## 72  2021-06-17T20:05:00Z
    ## 73  2021-06-16T23:38:40Z
    ## 74  2021-06-18T11:03:11Z
    ## 75  2021-06-16T12:46:07Z
    ## 76  2021-06-17T19:40:00Z
    ## 77  2021-06-15T04:45:00Z
    ## 78  2021-06-15T15:18:00Z
    ## 79  2021-06-12T06:46:17Z
    ## 80  2021-06-16T08:00:22Z
    ## 81  2021-06-16T17:00:00Z
    ## 82  2021-06-15T22:27:11Z
    ## 83  2021-06-17T18:14:00Z
    ## 84  2021-06-16T16:00:00Z
    ## 85  2021-06-10T14:00:09Z
    ## 86  2021-06-17T20:45:48Z
    ## 87  2021-06-09T14:36:27Z
    ## 88  2021-06-17T14:53:00Z
    ## 89  2021-06-17T14:23:02Z
    ## 90  2021-06-15T01:30:33Z
    ## 91  2021-06-16T23:32:07Z
    ## 92  2021-06-17T17:40:00Z
    ## 93  2021-06-17T23:50:30Z
    ## 94  2021-06-17T20:28:56Z
    ## 95  2021-06-17T16:14:25Z
    ## 96  2021-06-16T18:35:00Z
    ## 97  2021-06-17T17:15:36Z
    ## 98  2021-06-18T13:00:11Z
    ## 99  2021-06-16T18:07:31Z
    ## 100 2021-06-18T09:21:27Z
    ##                                                                                                                                                                                                                              content
    ## 1          Maybe the wall is to keep Ted Cruz from fleeing to Mexico the next time theres an emergency. JIMMY KIMMEL\r\nOK, so, one state can do its own foreign policy? It reminds me of that famous headline afterâ\200¦ [+552 chars]
    ## 2          10. And finally, let the funny business begin.\r\nOur TV critics compiled a list of their 21 favorite American comedies of the 21st century. In so doing, they reflected on just how much comedy has chanâ\200¦ [+697 chars]
    ## 3           In the film, contestants in the pageant are a range of sizes and unlike in traditional pageants many compete with their natural, unstraightened hair. When Kai takes the competition stage, she recitesâ\200¦ [+1354 chars]
    ## 4           Juneteenth has been celebrated by African Americans since the 19th century, and its broader popularity has waxed and waned throughout American history, according to Brenda Elaine Stevenson, a historiâ\200¦ [+1552 chars]
    ## 5         Proponents in both parties said the move was long overdue.\r\nFor far too long, the story of our countrys history has been incomplete, as we have failed to acknowledge, address and come to grips with oâ\200¦ [+1524 chars]
    ## 6           Throughout history, Juneteenth has been known by many names: Jubilee Day. Freedom Day. Liberation Day. Emancipation Day. And today, a national holiday, Vice President Kamala Harris said, introducing â\200¦ [+1625 chars]
    ## 7           From MTV star to hip-hop guru to international ambassador, Kevin Powell has seen it all. And hell bring that experience to Brower Park in Brooklyn on Saturday, performing an original poetry suite. Thâ\200¦ [+1624 chars]
    ## 8           Dr. Jackson, a former White House physician, has represented parts of northern Texas since January. I support Texas Juneteenth holiday and I support all Americans who celebrate it, he said in a stateâ\200¦ [+1729 chars]
    ## 9         media captionJuneteenth is a celebration of the freedom, culture and empowerment of African-Americans.\r\nThe Juneteenth National Independence Day Act, which establishes a holiday that commemorates theâ\200¦ [+4873 chars]
    ## 10          Mr. de Blasio is taking other measures to demonstrate a commitment to honoring Juneteenth. On Thursday, he announced a Friday Juneteenth celebration on the James Baldwin Lawn in Harlems St. Nicholas â\200¦ [+1867 chars]
    ## 11        This Saturday is Juneteenth, the annual holidayÂ long recognized by Black communities nationwide everyÂ June 19. It was on that date in 1865 when a Union general arrived in Galveston, Texas and informeâ\200¦ [+1965 chars]
    ## 12          A view of the exterior of the JP Morgan Chase &amp; Co. corporate headquarters in New York City May 20, 2015. REUTERS/Mike SegarJune 17 (Reuters) - JPMorgan Chase &amp; Co (JPM.N) will give its U.S. â\200¦ [+1332 chars]
    ## 13          U.S. President Joe Biden speaks prior to signing of the Juneteenth National Independence Day Act into law in the East Room of the White House in Washington, U.S., June 17, 2021. REUTERS/Carlos Barriaâ\200¦ [+3763 chars]
    ## 14          WASHINGTON, June 17 (Reuters) - U.S. President Joe Biden will sign a bill into law on Thursday afternoon to make June 19 a federal holiday commemorating the end of the legal enslavement of Black Amerâ\200¦ [+1399 chars]
    ## 15         By Reuters Staff\r\nJune 17 (Reuters) - The U.S. Centers for Disease Control and Prevention (CDC) on Thursday put off its meeting to discuss the occurrence of myocarditis among people who received COVIâ\200¦ [+391 chars]
    ## 16           The seal of the U.S. Securities and Exchange Commission (SEC) is seen at their headquarters in Washington, D.C., U.S., May 12, 2021. REUTERS/Andrew KellyWASHINGTON, June 17 (Reuters) - The U.S. Securâ\200¦ [+598 chars]
    ## 17          Norma Ewing of Seattle holds a sign as people gather at Judkins Park for Juneteenth, which commemorates the end of slavery in Texas, two years after the 1863 Emancipation Proclamation freed slaves elâ\200¦ [+2215 chars]
    ## 18       By Reuters Staff\r\nFILE PHOTO: The seal of the U.S. Securities and Exchange Commission (SEC) is seen at their headquarters in Washington, D.C., U.S., May 12, 2021. REUTERS/Andrew Kelly\r\nWASHINGTON (Reâ\200¦ [+511 chars]
    ## 19        The passage of the Juneteenth holiday. Illustrated | AP Images, iStock \r\nJuneteenth, a day commemorating the end of slavery in the United States, became the 11th federal holiday with overwhelming andâ\200¦ [+2599 chars]
    ## 20           Outrage erupted when social media spotted advertisements for the Historic Latta Plantation's racist Juneteenth celebration. Removing the advertisements did not erase the terrible, racist language theâ\200¦ [+985 chars]
    ## 21         Bed-Stuyâ\200\231s BLK MKT Vintagefounded by Jannah Handy and Kiyanna Stewartspecializes in second-hand delights from magazines to buttons, but this Juneteenth T-shirt is one of their own, new products. Commâ\200¦ [+286 chars]
    ## 22        If you have the day off of work on June 18 or 19, you can thank a small collective of Black artists and creative professionals in the Bay Area who call themselves Hella Creative.\r\nOver the past year,â\200¦ [+7289 chars]
    ## 23      Juneteenth marks when enslaved people in Texas learned that they had been freed under the Emancipation Proclamation.\r\nAbraham Lincoln Presidential Library and Museum via AP\r\nThe Senate unanimously apâ\200¦ [+1693 chars]
    ## 24        President Joe Biden on Thursday signed a bill into law that makes June 19, known as Juneteenth, a national holiday celebrating the end of slavery in the United States.\r\nVice President Kamala Harris oâ\200¦ [+2965 chars]
    ## 25        Sandra Quince has been readying for this moment her whole career. But still, it carried extra weight when nonprofit diversity-and-inclusion coalition Paradigm forÂ Parity named her its first-ever CEOÂ â\200¦ [+6999 chars]
    ## 26    Protesters last year chanted as they marched after a Juneteenth rally at the Brooklyn Museum, in the Brooklyn borough of New York.\r\nJohn Minchillo/AP\r\nOpal Lee is 94 and she's doing a holy dance. \r\nIâ\200¦ [+9833 chars]
    ## 27          Trump boasted that he "made Juneteenth very famous" by the backlash his campaign sparked by inadvertently scheduling a rally on the day in Tulsa, according to a forthcoming book by Wall Street Journaâ\200¦ [+2941 chars]
    ## 28        Juneteenth is Saturday, and Myrtle Beach area and state events are happening over the weekend to celebrate the emancipation of enslaved Black people in Galveston, Texas.\r\nAlso referred to as Juneteenâ\200¦ [+2346 chars]
    ## 29      By Reuters Staff\r\n(Repeats with no changes to text)\r\nJune 17 (Reuters) - JPMorgan Chase &amp; Co will give its U.S. employees one floating day off for the newly implemented Juneteenth federal holidayâ\200¦ [+1436 chars]
    ## 30      WASHINGTON -- \r\nThe United States will soon have a new federal holiday commemorating the end of slavery.\r\nThe House voted 415-14 on Wednesday to make Juneteenth, or June 19th, the 12th federal holidaâ\200¦ [+4407 chars]
    ## 31          Sen. Ron Johnson (R-Wisc.) on Tuesday announced he will no longer obstruct efforts to make Juneteenth a federal holiday and with that, the United States' second, fuller Independence Day may finally râ\200¦ [+1972 chars]
    ## 32        The United States will soon have a new federal holiday commemorating the end of slavery.\r\nThe House voted 415-14 on Wednesday to make Juneteenth, or June 19th, the 12th federal holiday, and Presidentâ\200¦ [+4613 chars]
    ## 33       Juneteenth is finally getting some mainstream recognition as a holiday. \r\nCelebrated on June 19, Juneteenth has sometimes been referred to as Americas second Independence Day. It was on that day in 1â\200¦ [+13872 chars]
    ## 34        The U.S. government is catching up with Black people who have been commemorating the end of slavery in the United States for generations with a day called Juneteenth.\r\nPresident Joe Biden is expectedâ\200¦ [+3774 chars]
    ## 35        WASHINGTON -- The Senate passed a bill Tuesday that would make Juneteenth, or June 19th, a federal holiday commemorating the end of slavery in the United States.\r\nThe bill would lead to Juneteenth beâ\200¦ [+2325 chars]
    ## 36          When you are Black in America, how do you celebrate progress? How do you honor the history and memory of emancipation, liberation, and advancement? How do Black people mark a moment when a positive câ\200¦ [+5547 chars]
    ## 37          For the first time in nearly 40 years, Congress has moved to establish a new national holiday, this time for Juneteenth, and just in time for Saturday's 156th anniversary of the day which marks the lâ\200¦ [+5963 chars]
    ## 38          Late summer at West Point is stiflingly hot. But, as a brand-new cadet standing nervously in military formation, I barely noticed. I was consumed with the environment surrounding me tall stone buildiâ\200¦ [+4694 chars]
    ## 39        The Town of Cary held its inaugural Juneteenth celebration in 2019, but this year marks the first time town employees will have a paid holiday in honor of the day.\r\nThe Town Council voted unanimouslyâ\200¦ [+3718 chars]
    ## 40        A racist event description, promising to tell the story of white refugees and defeated Confederate soldiers, was abruptly removed Friday by the Historic Latta Plantation after backlash.\r\nOn its websiâ\200¦ [+2246 chars]
    ## 41          Juneteenth is now officially a federal holiday, but the 14 House Republicans who voted against the Juneteenth National Independence Day Act's passage have some varying objections to the day of recognâ\200¦ [+1806 chars]
    ## 42          Juneteenth, a portmanteau of June 19, is a holiday that honors the end of slavery in the United States.On June 19, 1865, federal troops marched on Galveston, Texas, to take control of the state. Evenâ\200¦ [+2404 chars]
    ## 43          Mecklenburg County is not renewing its contract with the nonprofit that manages Historic Latta Plantation, after a controversial Juneteenth program planned for the Huntersville site sparked a social â\200¦ [+5741 chars]
    ## 44          Historic Latta Plantation refused to apologize Saturday for a controversial program whose racist Juneteenth event description promised to tell the story of white refugees and defeated Confederate solâ\200¦ [+4834 chars]
    ## 45          What, to the American slave, is your 4th of July? This is the question that formerly enslaved abolitionist Frederick Douglass posed in a July 1852 speech that would later become one of his most famouâ\200¦ [+6072 chars]
    ## 46          Opal Lee, the 94-year-old known as the Grandmother of Juneteenth due to her tireless campaigning to make the commemoration of the end of slavery in the U.S. a national federal holiday, had an off theâ\200¦ [+1736 chars]
    ## 47          Tomorrow is Juneteenth, commemorating the freeing of enslaved Black people in Texas on June 19, 1865. That was the day that Maj. Gen. Gordon Granger delivered a message to the people of Galveston, Teâ\200¦ [+1982 chars]
    ## 48           During the White House COVID-19 response team briefing on Thursday, Dr. Rochelle Walensky, director of the Centers for Disease Control and Prevention, said the seven-day daily average death rate due â\200¦ [+261 chars]
    ## 49          Today, President Biden "signed the Juneteenth National Independence Day Act, making Juneteenth a federal holiday," Jimmy Fallon said on Thursday's Tonight Show. "The bill hit Biden's desk after it waâ\200¦ [+2449 chars]
    ## 50          Congress moved one step closer to making Juneteenth a federal holiday this week, as the House overwhelmingly passed the Juneteenth National Independence Day Act last night following a unanimous vote â\200¦ [+3657 chars]
    ## 51        The United States will soon have a new federal holiday commemorating the end of slavery in the nation.\r\nCongress has approved a bill that would make Juneteenth, or 19 June, a holiday a bill Joe Bidenâ\200¦ [+4140 chars]
    ## 52        Biden to sign bill to make Juneteenth a federal holiday\r\nPresident Joe Biden on Thursday afternoon will sign into law the bill that makes Juneteenth a federal holiday, according to his official schedâ\200¦ [+4786 chars]
    ## 53   Skip to main content\r\nThis content is only available to USA TODAY subscribers.\r\nSubscribe for as low as $4.99 per month.\r\nYour subscription includes access to:\r\nExclusive, subscriber-only content andâ\200¦ [+796 chars]
    ## 54     Juneteenth celebrates the Emancipation Proclamation, but the Emancipation Proclamation didn't apply to all states in the USA. The 13th Amendment brought an end to slavery.\r\nWochit\r\nWASHINGTONÂ  The Hoâ\200¦ [+1730 chars]
    ## 55        President Joe Biden signed a bill Thursday afternoon making Juneteenth a federal holiday commemorating the end of slavery in the United States -- just in time for Saturday's June 19 anniversary.\r\nIt'â\200¦ [+5881 chars]
    ## 56          Black Americans rejoiced Thursday after President Joe Biden made Juneteenth a federal holiday, but some said that, while they appreciated the recognition, more is needed to change policies that disadâ\200¦ [+5027 chars]
    ## 57         This year marks the 156th commemoration of Juneteenth. The holiday has largely been celebrated in Texas and certain pockets throughout the American South, but in recent years, people across America aâ\200¦ [+12603 chars]
    ## 58          Theres nothing on Earth that gets stolen from more than Black culture. From our bodies being taken from Africa to every part of our identities being appropriated and fawned over, as infuriating as itâ\200¦ [+2502 chars]
    ## 59        I, like many others, didnt even know anything about Juneteenth until I was an adult, Chicago Mayor Lori Lightfoot said Monday to kick off Juneteenth celebrations in the city.\r\nAfter initially saying â\200¦ [+3187 chars]
    ## 60          Thank you kindly for the recognition, making Juneteenth a federal holiday, the literal least you could do coming some 150-plus years after wed already slathered the day in heaps of song, food, knowleâ\200¦ [+8773 chars]
    ## 61        This year, Iâ\200\231m celebrating Juneteenth with a full glass of red drink. The color red represents resilience in the Black community, and its symbolism can be traced back before slavery to Africa. In theâ\200¦ [+3297 chars]
    ## 62        WINSTON-SALEM, N.C. (AP) Officials in North Carolina have denounced plans now canceled by a historic museum to put on a reenactment of a white slave owner being pursued by Union soldiers.\r\nThe reenacâ\200¦ [+2457 chars]
    ## 63          Congress on Wednesday passed a bill recognizing Juneteenth as a federal holiday, even as a cultural war rages over conservative states efforts to ban school lessons around how the countrys history ofâ\200¦ [+5909 chars]
    ## 64          Last year, Bandcamp held a fundraiser on Juneteenth (June 19), a holiday commemorating the end of slavery in the United States. Now, the site has announced its second annual Juneteenth fundraiser. Onâ\200¦ [+1935 chars]
    ## 65          If you ask Black people born and raised on the island, Juneteenth marks the day Black soldiers in blue uniforms came with their guns to Galveston. That is the story they have told for generations, abâ\200¦ [+4305 chars]
    ## 66           The US will officially recognize Juneteenth as a federal holiday on 19 June after Joe Biden signed a bill into law which commemorates the end of slavery in the country. The president described a day â\200¦ [+260 chars]
    ## 67          The Confederate battle flag, which was crafted as a symbol of opposition to the abolishment of slavery, is just recently tired. We dont see it much anymore. However, on the 6th, when the stormers raiâ\200¦ [+2411 chars]
    ## 68        On Thursday, President Joe Biden signed legislation making Juneteenth a federal holiday.\r\nJuneteenth is on the 19th, but because that is a Saturday, all federal and Missouri state offices will be cloâ\200¦ [+1327 chars]
    ## 69          For more than two centuries, Americans have celebrated the countrys independence from Britain at neighborhood cookouts and fireworks displays. For Black Americans, however, the July 4 holiday has beeâ\200¦ [+7566 chars]
    ## 70        In preparation for a Juneteenth weekend full of celebrations, shared stories, gratitude, and good food, Iâ\200\231m sharing a decadent trifle that combines three of my Southern favorites: peaches, iced tea, â\200¦ [+9495 chars]
    ## 71         Kim Prince is scheduled to be one of the panelists at "Red Drinks for Juneteenth," a free virtual forum from Los Angeles Times Food Bowl. (Christina House / Los Angeles Times)\r\nCelebrate Juneteenth wâ\200¦ [+650 chars]
    ## 72        Exclusive: How will Washington quell the disdain in the Black community over Juneteenth becoming a federal holiday when voting rights and police reform bills remain in jeopardy?\r\nPresident Joe Biden â\200¦ [+4061 chars]
    ## 73     (Temi Coker / For The Times)\r\nThere are two ways people learn about Juneteenth: They seek it out or it finds them.\r\nFor some, Juneteenth is a recent revelation. Last years anti-police brutality proteâ\200¦ [+10566 chars]
    ## 74       Are you tired of dealing with a perpetual loop of Zoom meetings and Wi-Fi connectivity issues?\r\nWell, you can step outside this weekend and enjoy South Floridas sunny 90 degree weather while donning â\200¦ [+10264 chars]
    ## 75     I prioritize celebrating Juneteenth every year, and I think others should too.Â \r\nJuneteenth is a holiday marking our countryâ\200\231s second Independence Day. It commemorates the day in 1865 when General Goâ\200¦ [+7923 chars]
    ## 76           As Washington policymakers establish June 19, or Juneteenth, as a new federal holiday, the U.S. Office of Personnel Management, the agency in charge of such matters, said most employees will get Fridâ\200¦ [+160 chars]
    ## 77      June 15, 2021 AT 12:45 am\r\nAdafruit Celebrates Juneteenth 2021 #Juneteenth #Emancipation\r\nJune 19 is Juneteenth; a celebration of the emancipation of the last slaves in the US. This holiday deserves â\200¦ [+3078 chars]
    ## 78        EA's multiplayer dodgeball-battler Knockout City is getting a batch of Juneteenth related player icons later this week in its in-game shop. The icons will be free for all players.\r\nJuneteenth is celeâ\200¦ [+1656 chars]
    ## 79        Latta Plantation, Huntersville, North Carolina. Carol M. Highsmith/Buyenlarge/Getty Images\r\nA North Carolina Plantation canceled an event that would have told the stories of displaced "white refugeesâ\200¦ [+1441 chars]
    ## 80      Stop breadboarding and soldering â\200“ start making immediately! Adafruitâ\200\231s Circuit Playground is jam-packed with LEDs, sensors, buttons, alligator clip pads and more. Build projects with Circuit Playgroâ\200¦ [+2216 chars]
    ## 81           WASHINGTONIn a rare unanimous vote, the Senate passed a bill Wednesday to make Juneteenth a federal holiday so long as no one thinks too hard about its significance. This is a day to barbecue and getâ\200¦ [+990 chars]
    ## 82         This is huge, Rep. Brenda Lawrence (D-Mich.) tweeted after the vote. I look forward to passing this bill in the House and making #Juneteenth a federal holiday.\r\nRep. Brenda Lawrence, D-Mich., speaks â\200¦ [+613 chars]
    ## 83                                                                                                                                                                   Alls well that ends well, I say.\r\nVirgil McCain, Taffy Puller
    ## 84  Looks from the Spring 2020 Dolce &amp; Gabbana collection.Â \r\nPhoto: Imaxtree\r\nThese are the stories making headlines in fashion on Wednesday.\r\nDolce &amp; Gabbana is still not welcome in ChinaÂ Hong Kâ\200¦ [+2191 chars]
    ## 85      The Robert Randolph Foundation will host Unityfest, a livestream concert event in celebration of Juneteenth, on June 19th at 5:00 p.m. ET via the festivalâ\200\231s website.\r\nHosted by Amanda Seales and JB Sâ\200¦ [+2218 chars]
    ## 86        President Bidenjust made it official ... there's now a federal holiday marking a milestone in the abolishment of slavery in the United States.\r\nBiden put pen to paper Thursday, signing a landmark bilâ\200¦ [+2023 chars]
    ## 87          17-year-old prodigious artist and activist Diana Sinclair is commemorating Juneteenth the annual holiday celebrating the end of slavery in the United States with the curation of an art exhibition, puâ\200¦ [+2069 chars]
    ## 88         The Value Gap is a MarketWatch Q&amp;A series with business leaders, academics, policymakers and activists on how to reduce racial and social inequalities.Opal Lee, a 94-year-old activist and retiredâ\200¦ [+11132 chars]
    ## 89          US Congress this week overwhelmingly backed a proposal to make Juneteenth a national holiday, and president Joe Biden is expected to sign it into law today (June 17). In a rare show of bipartisan supâ\200¦ [+2248 chars]
    ## 90        Apple is encouraging Apple Pay users to shop Black-owned businesses on Juneteenth.\r\nJuneteenth, which celebrates the emancipation of those who had been enslaved in the United States, occurs on June 1â\200¦ [+1718 chars]
    ## 91        The United States Congress passed a bill on Wednesday to make Juneteenth, or June 19, a federal holiday commemorating the end of slavery in the country.\r\nBy an overwhelming vote, the US House followeâ\200¦ [+3381 chars]
    ## 92    Ibram X. Kendi stands for a portrait in 2019 following a panel discussion in Washington, DC, on his book How to Be an Antiracist. | Michael A. McCoy/Washington Post via Getty Images\r\n\n \n\n The author â\200¦ [+13062 chars]
    ## 93        Greetings, QuickTake readers! This week, Biden creates the first new national holiday since Martin Luther King Jr. Day. Plus: China gets one step closer to building its own space station. \r\nStream noâ\200¦ [+3098 chars]
    ## 94          Juneteenth commemorates the end of slavery in the United States. It's name is a portmanteau of the date it is celebrated on celebrated annually on June 19 and has been recognized by 45 states, to varâ\200¦ [+2615 chars]
    ## 95        The United States will soon have a new federal holiday commemorating the end of slavery.\r\nThe House voted 415-14 on Wednesday to make Juneteenth, or June 19th, the 12th federal holiday, and Presidentâ\200¦ [+4376 chars]
    ## 96            Businesswoman and fashion designer Tina Knowles-Lawson is helping Facebook celebrate Juneteenth (Saturday, June 19) with a video detailing her familys deep connection with the holiday, their Texas roâ\200¦ [+97 chars]
    ## 97        President Joe Biden is expected to sign a bill into law Thursday to make Juneteenth, the commemoration of the end of U.S. slavery, a federal holiday.\r\nThe legislation, officially named The Juneteenthâ\200¦ [+1502 chars]
    ## 98      Jas. I. Campbell, Historic American Buildings Survey: Ashton Villa, Photograph, 1934. Public domain, via Wikimedia Commons.\r\nThe long-held myth goes that on June 19, 1865, Union genÂ­eral Gordon Grangâ\200¦ [+11768 chars]
    ## 99        AMC Entertainment will present a weeklong AMC Black Picture Showcase at select theaters nationwide starting Friday to celebrate Juneteenth.\r\nThe newly established national holiday commemorates the abâ\200¦ [+1368 chars]
    ## 100         YWCA camp for girls. Highland Beach, Maryland, 1930. These photos are from the Scurlock Studio Collection at the Smithsonian National Museum of American History. Read more about the photos at the endâ\200¦ [+8364 chars]

## Building a word cloud

Use data from titles and visualize in a word cloud

  - Must ‘tokenize’ the titles and remove ‘stop words’ like “the” or “a”

  - `dplyr` and `tidytext` packages makes this very easy\!

>   - `unnest_tokens()` tokenizes the titles and creates a data frame

>   - A `stop_words` object is available with common words to remove
>     (sometimes you need to add to this)

>   - `anti_join()` the data frame from `unnest_tokens()` and the
>     `stop_words` data frame

>   - Sum up the number of times each word appears for weighting in the
>     word cloud (`count()` works well\!)

## Making data for word cloud

``` r
library(dplyr); library(tidytext)
wcData <- parsed$articles$title %>% 
  as_tibble() %>% 
  unnest_tokens(word, value) %>% 
  anti_join(stop_words) %>% 
  count(word, sort = TRUE)
wcData
```

    ## # A tibble: 326 x 2
    ##    word           n
    ##    <chr>      <int>
    ##  1 juneteenth    99
    ##  2 holiday       47
    ##  3 federal       28
    ##  4 bill          14
    ##  5 biden         12
    ##  6 u.s           10
    ##  7 â              9
    ##  8 black          8
    ##  9 day            8
    ## 10 slavery        8
    ## # ... with 316 more rows

## Word cloud via `wordcloud2` package

`wordcloud2` package easily creates nice looking word clouds

<center>

``` r
library(wordcloud2); wordcloud2(wcData[-1,])
```

<!--html_preserve-->

<div id="htmlwidget-5e791f085e78367b4bc3" class="wordcloud2 html-widget" style="width:672px;height:480px;">

</div>

<script type="application/json" data-for="htmlwidget-5e791f085e78367b4bc3">{"x":{"word":["holiday","federal","bill","biden","u.s","â","black","day","slavery","event","reuters","signs","congress","marking","national","americans","city","freedom","passes","plantation","senate","14","approves","celebrate","celebrating","celebration","create","emancipation","employees","free","friday","honor","house","law","paid","voted","votes","white","19","2021","94","announces","canceled","celebrates","close","colbert","companies","creatives","donâ","due","events","finally","food","fundraiser","global","hereâ","jpmorgan","juneteenthâ","kansas","makes","mayor","meet","meiko","nc","news","observe","offices","promo","racist","republicans","sec","sign","significance","signing","stephen","temple's","thursday","time","ubs","1","158","4","44","5","7","800","abolition","adafruit","adding","advertisement","african","alongside","amc","americaâ","american","angelenos","angeles","annual","anti","apology","apple","attends","backlash","bandcamp","bbq","belongs","bloggers","book","bowl","box","briefing","businesses","calls","campaigned","cancels","capitol","carolina","cary","cdc","celebrated","celebrations","ceo","chainâ","cheer","chic","chicago","chicken","china","claimed","closed","coleman's","comedies","commemorating","conceals","confusionâ","congressmen","continue","contract","controversial","cookout","corporate","covid","creating","critics","crowned","ctv","darius","decades","defeating","delays","depicting","designated","details","dolce","downes","drinks","effect","empty","encourages","enemy","entertainment","equity","erase","establishing","evening","excuses","explainer","facebook","factbox","fallon","famous","fargo","fashion","feels","fight","films","flag","forget","freeâ","fugitive","gabbana","gallery","galveston","gap","gesture","giving","groundwork","hard","heart","helped","hijacked","historic","history","holidayâ","hypocrisy","iâ","ibram","infrastructure","inspired","isnâ","itâ","items","jeer","jimmy","july","june","kendi","knockout","lara","late","latta","laying","led","lee","leeâ","legacy","legislation","limeade","list","los","marker","meck","miami","miss","multiply","n.y.c","nationâ","nft","nile","nonprofit","north","nypl","obamacare","offâ","official","opal","opinion","opposition","overdue","owned","owner","pay","people","perform","perspective","pianist","plans","playlist","poised","poll","president","profound","progress","public","push","racism","read","recipes","reckoning","recognition","red","refugeeâ","refugees","remain","removes","report","republicansâ","response","reuters.com","risk","robert","rodgers","rpt","rucker","sc","sets","shirt","shop","shots","showcase","showstopper","slams","slave","slaveowner","slavery's","songs","southern","spotlight","stories","story","style","talk","tees","thankful","times","told","town","tradition","treat","trifle","trump","unanimously","unimpressed","unityfest","update","users","usher","video","vine","virtual","vote","wasnâ","watchlist","watermelon","weâ","wednesday","week","weekend","weekly","weight","wings","woman","workers","worst","york"],"freq":[47,28,14,12,10,9,8,8,8,7,7,7,6,5,5,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],"fontFamily":"Segoe UI","fontWeight":"bold","color":"random-dark","minSize":0,"weightFactor":3.82978723404255,"backgroundColor":"white","gridSize":0,"minRotation":-0.785398163397448,"maxRotation":0.785398163397448,"shuffle":true,"rotateRatio":0.4,"shape":"circle","ellipticity":0.65,"figBase64":null,"hover":null},"evals":[],"jsHooks":{"render":[{"code":"function(el,x){\n                        console.log(123);\n                        if(!iii){\n                          window.location.reload();\n                          iii = False;\n\n                        }\n  }","data":null}]}}</script>

<!--/html_preserve-->

</center>

## Goals

  - Understand very basics of APIs

  - Contact an API using R
    
      - `httr:GET("URL")`

  - Process returned data
    
      - Often JSON data: `jsonlite` package  
      - Tokenize and remove stop words with `tidytext`

  - Create a word cloud
    
      - `wordcloud2` package
