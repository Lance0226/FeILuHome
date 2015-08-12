angular.module('starter.services', [])

.factory('Chats', function() {
  // Might use a resource here that returns a JSON array

  // Some fake testing data
  var chats = [{
    id: 0,
    name: '方案1',
    lastText: 'You on your way?',
    face: 'http://www.xuanran001.com/public/repository/c281/9a86/c3cd/4360/ab2a/dbf6/cd56/bce6/data/images/145b4d26-0087-4535-b7eb-cf764e0b5049/image/0000.jpg'
  },
  {
    id: 0,
    name: '方案2',
    lastText: 'You on your way?',
    face: 'http://www.xuanran001.com/public/repository/c281/9a86/c3cd/4360/ab2a/dbf6/cd56/bce6/data/images/145b4d26-0087-4535-b7eb-cf764e0b5049/image/0000.jpg'
  }
  ];

  return {
    all: function() {
      return chats;
    },
    remove: function(chat) {
      chats.splice(chats.indexOf(chat), 1);
    },
    get: function(chatId) {
      for (var i = 0; i < chats.length; i++) {
        if (chats[i].id === parseInt(chatId)) {
          return chats[i];
        }
      }
      return null;
    }
  };
});
