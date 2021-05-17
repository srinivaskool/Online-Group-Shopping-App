import 'package:flash_chat/models/offer.dart';

var users = [
  'images/user0.jpg',
  'images/user1.jpg',
  'images/user2.jpg',
  'images/user3.jpg',
  'images/user4.jpg',
  'images/user5.jpg',
  'images/user6.jpg',
];

var offers = [_offer0, _offer1, _offer2,_offer3,_offer4,_offer5];

final _offer0 = Offer(
  imageUrl: 'images/post0.jpg',
  title: '50% Off',
  location: 'Amazon',
  likes: 102,
);

final _offer1 = Offer(
  imageUrl: 'images/post1.jpg',
  title: '35% Off',
  location: 'Flipkart',
  likes: 291,
);

final _offer2 = Offer(
  imageUrl: 'images/post2.jpg',
  title: '15% Off',
  location: 'Ajile',
  likes: 189,
);

final _offer3 = Offer(
  imageUrl: 'images/post3.jpg',
  title: '25% Off',
  location: 'Snapdeal',
  likes: 302,
);

final _offer4 = Offer(
  imageUrl: 'images/post4.jpg',
  title: '40% Off',
  location: 'Tata Cliq',
  likes: 416,
);

final _offer5 = Offer(
  imageUrl: 'images/post5.jpg',
  title: '20% Off',
  location: 'Reliance Trends',
  likes: 782,
);

