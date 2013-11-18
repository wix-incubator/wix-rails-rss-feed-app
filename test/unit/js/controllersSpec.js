'use strict';

describe('WidgetCtrl', function(){
    var scope, window, settingsService, feedService;

    beforeEach(module('rss'));

    beforeEach(inject(function($rootScope, $window, $controller, $q, SettingsService, FeedService){
        scope = $rootScope.$new();
        feedService = FeedService;
        settingsService = SettingsService;
        window =  {
            settings : {'numOfEntries':'4', 'feedUrl':'http://rss.cnn.com/rss/edition.rss', connected : false}
        };
        var deferred = $q.defer();
        deferred.resolve({'data': {'responseData': {'feed' : {'entries' : [{'someJSONObject' : {}}], 'title' : 'Feed Title'}}}});
        spyOn(feedService, 'parseFeed').andReturn(deferred.promise);
        $controller('WidgetCtrl', {$scope: scope, $window: window, SettingsService: settingsService, FeedService: feedService});
    }));


    it('should store settings in scope', function() {
        scope.init();
        expect(scope.settings).toEqual(window.settings);
    });

    it('should get feed', function() {
        scope.init();
        scope.$apply();
        expect(scope.title).toEqual('Feed Title');
        expect(scope.feeds).toEqual([{'someJSONObject' : {}}]);
    })
});

describe('SettingsCtrl', function(){
    var scope, window, settingsService, $httpBackend, settings, wixService;

    beforeEach(module('rss'));

    beforeEach(inject(function($rootScope, $window, _$httpBackend_, $controller, $q, SettingsService, Settings){
        scope = $rootScope.$new();
        settingsService = SettingsService;
        settings = Settings;
        window =  {
            settings : {'numOfEntries':'4', 'feedUrl':'http://rss.cnn.com/rss/edition.rss', connected : false}
        };
        wixService = jasmine.createSpyObj('wixService', ['initialize', 'getOrigCompId', 'refreshAppByCompIds']);
        $controller('SettingsCtrl', {$scope: scope, $window: window, SettingsService: settingsService, Settings: settings, WixService : wixService});
    }));


    it('should store settings in scope', function() {
        scope.init();
        expect(scope.settings).toEqual(window.settings);
    });

    it('should call Wix init on load', function() {
        scope.init();
        expect(wixService.initialize).toHaveBeenCalled();
    });

    it('should set user as connected when user enter feed url', function() {
        scope.init();
        scope.connect(true);
        expect(scope.settings.connected).toBeTruthy();
    })

    it('should set user as not connected when user clicks disconnect', function() {
        scope.init();
        scope.connect(false);
        expect(scope.connected).toBeFalsy();
    })
});