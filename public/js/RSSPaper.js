
(function($){
  _.templateSettings = {
    interpolate : /\{\{(.+?)\}\}/g
  };
  
  window.RSSFeed = Backbone.Model.extend({
  });
  
  window.RSSFeeds = Backbone.Collection.extend({
    model: RSSFeed,
    url: "/rss"
  });
  
  window.Feeds = new RSSFeeds();
  
  $(document).ready(function() {
    
    window.RSSView = Backbone.View.extend({
      template: _.template($('#rss-feed-template').html()),
      tag: 'li',
      initialize: function() {
        _.bindAll(this, 'render');
      },
      
      render: function() {
        $(this.el).html(this.template(this.model.toJSON()));
        return this;
      }
    });
    
    window.RSSListView = Backbone.View.extend({
      tagName: 'section',
      template: _.template($('#feeds-template').html()),
      initialize: function() {
        _.bindAll(this, 'render');
        this.collection.bind('reset', this.render);
      },
      
      render: function() {
       var $feeds;
       collection = this.collection;
       
       $(this.el).html(this.template({}));
       $feeds = this.$(".feeds");
       this.collection.each(function(feed) {
         var view = new RSSView({
           model: feed,
           collection: collection
         });
         $feeds.append(view.render().el);
       });
       
       return this; 
      }
    });
    
    window.RSSPaper = Backbone.Router.extend({
      routes: {
        '': 'home'
      },
      
      initialize: function() {
        this.rssListView = new RSSListView({
          collection: window.Feeds
        });
      },
      
      home: function() {
        $('#container').empty();
        $('#container').append(this.rssListView.render().el);
      }
    });

  });
  
})(jQuery);
