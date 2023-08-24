import 'package:flutter/material.dart';

class Specifications {
  final String fuel;
  final String engine;
  final String power;
  final String drivetrain;
  final String acceleration;
  final String seating;

  Specifications({
    required this.fuel,
    required this.engine,
    required this.power,
    required this.drivetrain,
    required this.acceleration,
    required this.seating,
  });

  factory Specifications.fromJson(Map<String, dynamic> json) {
    return Specifications(
      fuel: json['fuel'],
      engine: json['engine'],
      power: json['power'],
      drivetrain: json['drivetrain'],
      acceleration: json['acceleration'],
      seating: json['seating'],
    );
  }
}

class Car {
  final String id;
  final String name;
  final String brand;
  final String year;
  final String price;
  final String rating;
  final Specifications specifications;
  final String image;

  Car({
    required this.id,
    required this.name,
    required this.brand,
    required this.year,
    required this.price,
    required this.rating,
    required this.specifications,
    required this.image,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['_id'],
      name: json['name'],
      brand: json['brand'],
      year: json['year'],
      price: json['price'],
      rating: json['rating'],
      specifications: Specifications.fromJson(json['specificatios']),
      image: json['Image'],
    );
  }
}


// final List<Car> cars2 = [
//   new Car(
//       name: 'BMW iX1',
//       brand: 'BMW',
//       price: '240USD',
//       rating: '4.5',
//       desc: 'It is a BMW Car',
//       img:
//           'https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/2020_BMW_M235i_xDrive_Gran_Coupe_Front.jpg/523px-2020_BMW_M235i_xDrive_Gran_Coupe_Front.jpg',
//       logo:
//           'https://static.vecteezy.com/system/resources/previews/021/671/890/original/bmw-logo-transparent-free-png.png',
//       year: '2023'),
//   Car(
//       name: 'Audi Q6 e-tron',
//       brand: 'AUDI',
//       price: '200USD',
//       rating: '4.2',
//       desc: 'It is a Audi Car',
//       img:
//           'https://www.audi.com/content/dam/gbp2/experience-audi/audi-sport/audi-racing-models/landingpage/1920x1080_A215400_large.jpg?imwidth=1920&imdensity=1',
//       logo:
//           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQyNnM8TYQcDs-xoOUgios_Krp1RbA9s3Q6g',
//       year: '2023'),
//   Car(
//       name: 'Mercedes-Benz EQS SUV',
//       brand: 'BENZ',
//       price: '180USD',
//       rating: '4.3',
//       desc: 'This is a Buggati',
//       img:
//           'https://akm-img-a-in.tosshub.com/businesstoday/images/story/202302/202302230723-main-sixteen_nine.jpg',
//       logo:
//           'https://banner2.cleanpng.com/20180126/irw/kisspng-mercedes-benz-sprinter-car-mercedes-benz-s-class-m-mercedes-logo-5a6b1571a578e4.0144230715169672816778.jpg',
//       year: '2023'),
//   Car(
//       name: 'Bugatti Chiron',
//       brand: 'BUGGATI',
//       price: '250USD',
//       rating: '4.8',
//       desc: 'Buggati is the best',
//       img:
//           'https://www.bugatti.com/fileadmin/_processed_/sei/p54/se-image-4799f9106491ebb58ca3351f6df5c44a.jpg',
//       logo: 'https://pngimg.com/uploads/bugatti_logo/bugatti_logo_PNG2.png',
//       year: '2023'),
//   Car(
//       name: 'Lamborghini Revuelto',
//       brand: 'LAMBO',
//       price: '205USD',
//       rating: '4.7',
//       desc: 'Lambo is just lub',
//       img:
//           'https://www.lamborghini.com/sites/it-en/files/DAM/lamborghini/facelift_2019/models_gw/2023/03_29_revuelto/gate_models_og_01.jpg',
//       logo:
//           'https://upload.wikimedia.org/wikipedia/en/thumb/d/df/Lamborghini_Logo.svg/1200px-Lamborghini_Logo.svg.png',
//       year: '2023'),
//   Car(
//       name: 'Aventador SVJ',
//       brand: 'LAMBO',
//       price: '320USD',
//       rating: '4.6',
//       desc:
//           'There`s a new ultra-performance Aventador SVJ model for 2019. The new model packs 759 horsepower, costs 521,265USD and hits 60 mph in 2.6 seconds',
//       img:
//           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQomlzo7PJqbpOdLvVxHd0W2c27blb5ebJJXRPH7IyZMA&s',
//       logo:
//           'https://upload.wikimedia.org/wikipedia/en/thumb/d/df/Lamborghini_Logo.svg/1200px-Lamborghini_Logo.svg.png',
//       year: '2019'),
//   Car(
//       name: 'Ford Mustang',
//       brand: 'FORD',
//       price: '150USD',
//       rating: '4.1',
//       desc: 'It is a Ford Car',
//       img:
//           'https://imgd.aeplcdn.com/1920x1080/cw/ec/23766/Ford-Mustang-Exterior-126883.jpg?wm=0&q=75',
//       logo:
//           'https://brandslogos.com/wp-content/uploads/images/large/ford-logo-black-and-white.png',
//       year: '2020'),
//   Car(
//       name: 'Chevrolet Camaro',
//       brand: 'CHEVROLET',
//       price: '160USD',
//       rating: '4.0',
//       desc: 'It is a Chevrolet Car',
//       img:
//           'https://static.autox.com/uploads/2023/06/2024-Chevrolet-Camaro-Collector-s-Edition.jpg',
//       logo:
//           'https://logos-world.net/wp-content/uploads/2021/03/Chevrolet-Logo.png',
//       year: '2022'),
//   Car(
//     name: 'Tesla Model S',
//     brand: 'TESLA',
//     price: '220USD',
//     rating: '4.6',
//     desc: 'It is a Tesla Car',
//     img:
//         'https://www.cnet.com/a/img/resize/0414cfceb258646269f2ce0778f078b5b303c465/hub/2021/11/15/4a37f89b-b7dd-4d91-a2b3-bdd94e90741b/0x0-models-22.jpg?auto=webp&fit=crop&height=675&width=1200',
//     logo: 'https://1000logos.net/wp-content/uploads/2018/02/Logo-Tesla.jpg',
//     year: '2022',
//   ),
//   Car(
//       name: 'X3 SAV sDrive30i',
//       brand: 'BMW',
//       price: '47,945 USD',
//       rating: '4.3',
//       desc: '''
//       2.0L I-4 cyl Engine: Automatic
//       25/29 mpg City/Hwy
//       Exterior 0C1M Phytonic Blue M
//       Interior Black ''',
//       img:
//           'https://images.dealer.com/ddc/vehicles/2021/BMW/X3/SUV/trim_sDrive30i_b065e9/color/Phytonic%20Blue%20Metallic-C1M-14%2C42%2C64-640-en_US.jpg?impolicy=downsize_bkpt&imdensity=1&w=520',
//       logo:
//           'https://static.vecteezy.com/system/resources/previews/021/671/890/original/bmw-logo-transparent-free-png.png',
//       year: '2021'),
//   Car(
//       name: 'X1 SAV xDrive28i',
//       brand: 'BMW',
//       price: '43,295 USD',
//       rating: '3.8',
//       desc: '''
//         2.0L I-4 cyl   Engine: Automatic
//         25/34 mpg City/Hwy  Alpine White
//         Exterior Black Perforated
//         Interior SensaTec
//       ''',
//       img:
//           'https://pictures.dealer.com/b/bramanbmwbmw/0643/4788b279e5a79ae8cb781da761cf164fx.jpg?impolicy=downsize_bkpt&imdensity=1&w=520',
//       logo:
//           'https://static.vecteezy.com/system/resources/previews/021/671/890/original/bmw-logo-transparent-free-png.png',
//       year: '2022'),
//   Car(
//       name: 'Audi S5 Sportback',
//       brand: 'AUDI',
//       price: '35,780 USD',
//       rating: '4.6',
//       desc: '''
//       Fuel Type :Petrol  Engine : 2994 cc
//       Power and Torque : 349 bhp & 500 Nm
//       DriveTrain :AWD
//       Acceleration : 4.8 seconds
//       Top Speed : 250 kmph''',
//       img: 'https://imgd.aeplcdn.com/664x374/n/cw/ec/51378/s5-sportback-exterior-right-front-three-quarter-5.jpeg?q=75',
//       logo: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQyNnM8TYQcDs-xoOUgios_Krp1RbA9s3Q6g',
//       year: '2022')
// ];
