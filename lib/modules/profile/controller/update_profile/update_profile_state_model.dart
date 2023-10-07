import 'package:equatable/equatable.dart';

import 'update_profile_cubit.dart';

class UpdateSellerProfileStateModel extends Equatable {
  final String image;
  final String name;
  final String email;
  final String phone;
  final String country;
  final String countryState;
  final String city;
  final String zipCode;
  final String address;
  final UpdateProfileState updateProfileState;

  const UpdateSellerProfileStateModel({
    this.image = '',
    this.name = '',
    this.email = '',
    this.phone = '',
    this.country = '',
    this.countryState = '',
    this.city = '',
    this.zipCode = '',
    this.address = '',
    this.updateProfileState = const UpdateProfileInitial(),
  });

  UpdateSellerProfileStateModel copyWith({
    String? image,
    String? name,
    String? email,
    String? phone,
    String? country,
    String? countryState,
    String? city,
    String? zipCode,
    String? address,
    UpdateProfileState? updateProfileState,
  }) {
    return UpdateSellerProfileStateModel(
      image: image ?? this.image,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      countryState: countryState ?? this.countryState,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      address: address ?? this.address,
      updateProfileState: updateProfileState ?? this.updateProfileState,
    );
  }

  Map<String, String> toMap() {
    return <String, String>{
      'image': image,
      'name': name,
      'email': email,
      'phone': phone,
      'country': country,
      'state': countryState,
      'city': city,
      'zip_code': zipCode,
      'address': address,
    };
  }

  UpdateSellerProfileStateModel clear() {
    return const UpdateSellerProfileStateModel(
      image: '',
      name: '',
      email: '',
      phone: '',
      country: '',
      countryState: '',
      city: '',
      zipCode: '',
      address: '',
      updateProfileState: UpdateProfileInitial(),
    );
  }

  @override
  List<Object> get props {
    return [
      image,
      name,
      email,
      phone,
      country,
      countryState,
      city,
      zipCode,
      address,
      updateProfileState,
    ];
  }
}
