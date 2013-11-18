var services = angular.module('rss.services', ['ngResource']);

services.factory('FeedService', ['$http', function($http){
    return {
        parseFeed : function(url){
            return $http.jsonp('//ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=50&callback=JSON_CALLBACK&q=' + encodeURIComponent(url));
        }
    }
}]);

services.factory('Settings', ['$resource', '$location', function($resource, $location) {
    return $resource('/app/settingsupdate?instance=' + ($location.search()).instance,
        {headers: {'Content-Type': 'application/json'}},
        {}
    );
}]);

services.factory("SettingsService", ['$window', function($window) {
    return {
        settings : function() {
            var settings = $.extend(
                {'numOfEntries': '4',
                      'feedUrl': 'http://rss.cnn.com/rss/edition.rss',
                      'connected' : false
                },
                $window.settings);
            return settings;
        }
    };
}]);

services.factory('WixService', function() {
    return {
        initialize : function() {
            return Wix.UI.initialize();
        },
        getOrigCompId : function() {
            return Wix.Utils.getOrigCompId();
        },
        refreshAppByCompIds : function(compId) {
            return Wix.Settings.refreshAppByCompIds(compId);
        }
    }
});