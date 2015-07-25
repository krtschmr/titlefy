# Titlefy

Awesome titletag helper with I18n support.

## Usage
Define your tiltetags within one structured file. Just simply do the following:

```ruby
gem "titlefy", git: 'git://github.com/krtschmr/titlefy.git'
```

Create an YML file and add the :title_tags scope. Define what you need


#### Default TilteTag
    en:
      title_tags:
        default: My Awesome Webpage

##### TitleTag by route_name
    en:
      title_tags:
        list_items_path: Index of Items
        order_path: Order at our Webshop
    
#### TitleTag by Controller/Action      
    en:
      title_tags:
        files_controller:
          index: List of all Files
          new: Create a new File

#### Titletag by Controller in Namespace        
For Admin::PagesController

    en:
      title_tags:
        admin: 
          dashboard_conroller:
            index: Overview
            stats: Detailed Stats
            
            
            
Lookup order is Namespace/Controller/Action, Controller/Action, RouteName, Default, RaillsAppName. 
Simply set the titletag from your controller like this
````
  def index
    set_title("MY special title")
  end
````


# TODO
- Multi Namespacing Support
- Add Params to support something like this "show: Item Number %(id)"
