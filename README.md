# Titlefy

Awesome title tag magic with I18n support, passing variables and default title. 
No more unnecessary lines in each controller method, no more setting title tags out of a view. 
Avoid messy code - be slim and dry - kepp just one central place to control all your title tags!

## Usage
Define your tiltetags within one structured file. Just simply do the following:

```ruby
gem "titlefy", git: 'git://github.com/krtschmr/titlefy.git'
```

Using @page_title into your HTML 
````
  <title><%=@page_title %></title>
````



Create an YML file and add the :title_tags scope. Define what you need


#### Default TilteTag
    en:
      title_tags:
        default: My Awesome Webpage

##### TitleTag by route_name
    en:
      title_tags:
        routes:
          list_items_path: Index of Items
          order_path: Order at our Webshop
    
#### TitleTag by Controller/Action      
    en:
      title_tags:
        files_controller:
          index: List of all Files
          new: Create a new File          

#### Titletag by Controller in Namespace        
For Admin::DashboardController

    en:
      title_tags:
        admin: 
          dashboard_conroller:
            index: Overview
            stats: Detailed Stats
            
            

#### Using variables in title tag

    en:
      title_tags:  
        users_controller:
          show: Details of user: {{@user.name}}
          videos:
            index: Videos of user: {{@user.name}}
            show: Video "{{@video.name}} from {{@user.name}} posted on {{@video.time}}"


It also supports any kind of resource-controller where the object is called "resource"

    en:
      title_tags:  
        routes: 
          dogs_path: "{{resource.funky_dog_name}} - my-petwebsite"
          cats_path: "{{resource.funky_cat_name}} - my-petwebsite"

**Important!**
If your title-tag starts with a placeholder its neccessary to **start with quotes** to keep valid YML.


            
Lookup order is Namespace/Controller/Action, Controller/Action, RouteName, Default, RaillsAppName. 
Simply set the titletag from your controller like this
````
  def index
    set_title("MY special title")
  end
````


# TODO
- Multi Namespacing Support

### Changelog

0.3.0 
 - supports passing of variables
 - changed lookup path of routes
 - changed @title to @page_title

0.2.0 rewritten code from 2012


thanks to [phillipp](https://github.com/phillipp)