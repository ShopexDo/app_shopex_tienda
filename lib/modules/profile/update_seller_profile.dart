import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seller_app/core/remote_urls.dart';
import 'package:seller_app/modules/profile/model/country_model.dart';

import '/utils/constants.dart';
import '/utils/loading_widget.dart';
import '/utils/utils.dart';
import '/widgets/error_text.dart';
import '/widgets/primary_button.dart';
import '../../widgets/custom_image.dart';
import 'component/profile_images.dart';
import 'controller/country_state_city/country_state_city_cubit.dart';
import 'controller/seller_profile_cubit.dart';
import 'controller/update_profile/update_profile_cubit.dart';
import 'controller/update_profile/update_profile_state_model.dart';
import 'model/city_by_state_model.dart';
import 'model/seller_profile_model.dart';
import 'model/state_by_country_model.dart';

class UpdateSellerProfileScreen extends StatefulWidget {
  const UpdateSellerProfileScreen({Key? key, required this.seller})
      : super(key: key);
  final SellerProfileModel seller;

  @override
  State<UpdateSellerProfileScreen> createState() =>
      _UpdateSellerProfileScreenState();
}

class _UpdateSellerProfileScreenState extends State<UpdateSellerProfileScreen> {
  CountryModel? _country;
  StateByCountryModel? _stateByCountry;
  CityByStateModel? _cityByState;

  List<CountryModel> countryList = [];
  List<StateByCountryModel> stateList = [];
  List<CityByStateModel> cityList = [];

  @override
  void initState() {
    initializedExistingValue();
    super.initState();
  }

  initializedExistingValue() {
    loadCountryStateCity();
    //
    // context
    //     .read<UpdateSellerProfileCubit>()
    //     .imageChange(widget.seller.user!.image);
    context
        .read<UpdateSellerProfileCubit>()
        .nameChange(widget.seller.user!.name);
    context
        .read<UpdateSellerProfileCubit>()
        .emailChange(widget.seller.user!.email);
    context
        .read<UpdateSellerProfileCubit>()
        .phoneChange(widget.seller.user!.phone);

    context
        .read<UpdateSellerProfileCubit>()
        .countryChange(widget.seller.user!.countryId.toString());
    context
        .read<UpdateSellerProfileCubit>()
        .countryStateChange(widget.seller.user!.stateId.toString());
    context
        .read<UpdateSellerProfileCubit>()
        .zipCodeChange(widget.seller.user!.zipCode.toString());
    context
        .read<UpdateSellerProfileCubit>()
        .cityChange(widget.seller.user!.cityId.toString());
    context
        .read<UpdateSellerProfileCubit>()
        .addressChange(widget.seller.user!.address);
  }

  loadCountryStateCity() {
    //context.read<CountryStateCityCubit>().countryList = countryList;
    countryList = widget.seller.countries!;
    context.read<CountryStateCityCubit>().stateList = widget.seller.states!;
    context.read<CountryStateCityCubit>().cityList = widget.seller.cities!;

    // for (var e in widget.seller.countries!) {
    //   if (e.id.toString() == widget.seller.user!.countryId.toString()) {
    //     _country = e;
    //   }
    //   break;
    // }

    _country =
        context.read<SellerProfileCubit>().defaultCountry(widget.seller.user!);
    _stateByCountry = context
        .read<SellerProfileCubit>()
        .defaultState(widget.seller.user!.stateId.toString());

    if (_stateByCountry != null) {
      _cityByState = context
          .read<SellerProfileCubit>()
          .defaultCity(widget.seller.user!.cityId.toString());
    }
  }

  _loadState(CountryModel countryModel) {
    _country = countryModel;
    _stateByCountry = null;
    _cityByState = null;

    context
        .read<CountryStateCityCubit>()
        .getStateByCountry(countryModel.id.toString());
  }

  _loadCity(StateByCountryModel stateModel) {
    _stateByCountry = stateModel;
    _cityByState = null;
    context
        .read<CountryStateCityCubit>()
        .getCityByState(stateModel.id.toString());
  }

  final space = const SizedBox(height: 16.0);
  final _className = 'UpdateSellerProfileScreen';

  @override
  Widget build(BuildContext context) {
    final profile = widget.seller.user!;
    final profileCubit = context.read<UpdateSellerProfileCubit>();
    // print(state.image);
    // print(state.name);
    // print(state.email);
    // print(state.phone);
    // print(state.country);
    // print(state.countryState);
    // print(state.city);
    // print(state.zipCode);
    // print(state.address);
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Actualizar Perfil',
            style: TextStyle(color: blackColor),
          ),
          backgroundColor: primaryColor),
      body:
          BlocListener<UpdateSellerProfileCubit, UpdateSellerProfileStateModel>(
        listener: (_, state) {
          final update = state.updateProfileState;
          print(update);
          if (update is UpdateProfileStateLoading) {
            log(update.toString(), name: _className);
          } else if (update is UpdateProfileStateError) {
            Utils.errorSnackBar(context, update.message);
          } else if (update is UpdateProfileStateLoaded) {
            Navigator.of(context).pop();
            // Navigator.of(context).pop(true);
            // Navigator.pop(context);
            context.read<SellerProfileCubit>().getSellerProfile();
            Utils.showSnackBar(context, update.message);
          }
        },
        child: BlocBuilder<CountryStateCityCubit, CountryStateCityState>(
          builder: (context, state) {
            if (state is StateByCountryLoaded) {
              _stateByCountry = context
                  .read<CountryStateCityCubit>()
                  .filterState(widget.seller.user!.stateId.toString());

              if (_stateByCountry != null) {
                _cityByState = context
                    .read<CountryStateCityCubit>()
                    .filterCity(widget.seller.user!.cityId.toString());
              }
            }
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 20.0),
                ProfileImages(seller: widget.seller),
                // _buildImage(),
                space,
                BlocBuilder<UpdateSellerProfileCubit,
                    UpdateSellerProfileStateModel>(
                  builder: (_, state) {
                    final update = state.updateProfileState;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                            initialValue: profile.name,
                            onChanged: (String name) =>
                                profileCubit.nameChange(name),
                            decoration: const InputDecoration(hintText: 'Nombre'),
                            keyboardType: TextInputType.name),
                        if (update is UpdateProfileStateFormValidate) ...[
                          if (update.errors.name.isNotEmpty)
                            ErrorText(text: update.errors.name.first)
                        ]
                      ],
                    );
                  },
                ),
                space,
                BlocBuilder<UpdateSellerProfileCubit,
                    UpdateSellerProfileStateModel>(
                  builder: (_, state) {
                    final update = state.updateProfileState;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                            initialValue: profile.email,
                            onChanged: (String name) =>
                                profileCubit.emailChange(name),
                            decoration:
                                const InputDecoration(hintText: 'Correo'),
                            keyboardType: TextInputType.emailAddress),
                        if (update is UpdateProfileStateFormValidate) ...[
                          if (update.errors.email.isNotEmpty)
                            ErrorText(text: update.errors.email.first)
                        ]
                      ],
                    );
                  },
                ),
                space,
                BlocBuilder<UpdateSellerProfileCubit,
                    UpdateSellerProfileStateModel>(
                  builder: (_, state) {
                    final update = state.updateProfileState;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: profile.phone,
                          onChanged: (String name) =>
                              profileCubit.phoneChange(name),
                          decoration: const InputDecoration(hintText: 'Teléfono'),
                          keyboardType: TextInputType.number,
                        ),
                        if (update is UpdateProfileStateFormValidate) ...[
                          if (update.errors.phone.isNotEmpty)
                            ErrorText(text: update.errors.phone.first)
                        ]
                      ],
                    );
                  },
                ),
                space,
                // _countryField(),
                BlocBuilder<UpdateSellerProfileCubit,
                    UpdateSellerProfileStateModel>(
                  builder: (_, state) {
                    final update = state.updateProfileState;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _countryField(),
                        if (update is UpdateProfileStateFormValidate) ...[
                          if (update.errors.country.isNotEmpty)
                            ErrorText(text: update.errors.country.first)
                        ]
                      ],
                    );
                  },
                ),
                space,
                _stateField(),
                space,
                _cityField(),

                space,

                BlocBuilder<UpdateSellerProfileCubit,
                    UpdateSellerProfileStateModel>(
                  builder: (_, state) {
                    final update = state.updateProfileState;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: profile.zipCode.toString(),
                          onChanged: (String name) =>
                              profileCubit.zipCodeChange(name),
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(hintText: 'Código Postal'),
                        ),
                        if (update is UpdateProfileStateFormValidate) ...[
                          if (update.errors.zipCode.isNotEmpty)
                            ErrorText(text: update.errors.zipCode.first)
                        ]
                      ],
                    );
                  },
                ),
                space,
                BlocBuilder<UpdateSellerProfileCubit,
                    UpdateSellerProfileStateModel>(
                  builder: (_, state) {
                    final update = state.updateProfileState;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: profile.address,
                          onChanged: (String name) =>
                              profileCubit.addressChange(name),
                          decoration:
                              const InputDecoration(hintText: 'Dirección'),
                        ),
                        if (update is UpdateProfileStateFormValidate) ...[
                          if (update.errors.address.isNotEmpty)
                            ErrorText(text: update.errors.address.first)
                        ]
                      ],
                    );
                  },
                ),
                space,
                BlocBuilder<UpdateSellerProfileCubit,
                    UpdateSellerProfileStateModel>(
                  builder: (_, state) {
                    final update = state.updateProfileState;
                    if (update is UpdateProfileStateLoading) {
                      return const LoadingWidget();
                    }
                    return PrimaryButton(
                      text: 'Actualizar Perfil',
                      onPressed: () {
                        Utils.closeKeyBoard(context);
                        profileCubit.updateSellerProfile();
                      },
                    );
                  },
                ),
                const SizedBox(height: 60.0),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildImage() {
    final updateCubit = context.read<UpdateSellerProfileCubit>();
    return BlocBuilder<UpdateSellerProfileCubit, UpdateSellerProfileStateModel>(
      buildWhen: (previous, current) => previous.image != current.image,
      builder: (context, state) {
        String profileImage = widget.seller.user!.image.isNotEmpty
            ? RemoteUrls.imageUrl(widget.seller.user!.image)
            : RemoteUrls.imageUrl(widget.seller.defaultProfile!.image);

        profileImage = state.image.isNotEmpty ? state.image : profileImage;

        print('userImage: ${widget.seller.user!.image}');
        print('defaul: ${widget.seller.defaultProfile!.image}');
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0xff333333).withOpacity(.18),
                blurRadius: 70,
              ),
            ],
          ),
          child: Center(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CustomImage(
                    path: profileImage,
                    height: 170,
                    width: 170,
                    fit: BoxFit.cover,
                    isFile: state.image.isNotEmpty,
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: InkWell(
                    onTap: () async {
                      final imageSourcePath = await Utils.pickSingleImage();
                      updateCubit.imageChange(imageSourcePath!);
                    },
                    child: const CircleAvatar(
                      backgroundColor: primaryColor,
                      child: Icon(Icons.edit, color: blackColor),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _countryField() {
    final countryStateCity = context.read<CountryStateCityCubit>();
    return DropdownButtonFormField<CountryModel>(
      value: _country,
      isDense: true,
      isExpanded: true,
      hint: const Text('Country'),
      icon: const Icon(Icons.keyboard_arrow_down_outlined),
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: borderColor)),
      ),
      items: widget.seller.countries!
          .map<DropdownMenuItem<CountryModel>>(
            (CountryModel c) => DropdownMenuItem(
              value: c,
              child: Text(c.name),
            ),
          )
          .toList(),
      onChanged: (val) {
        if (val == null) return;
        _loadState(val);
        context
            .read<UpdateSellerProfileCubit>()
            .countryChange(val.id.toString());
        print('countryIdDrop: ${val.id.toString()}');
      },
    );
  }

  Widget _stateField() {
    final countryStateCity = context.read<CountryStateCityCubit>();
    return DropdownButtonFormField<StateByCountryModel>(
      value: _stateByCountry,
      isDense: true,
      isExpanded: true,
      hint: const Text('State'),
      icon: const Icon(Icons.keyboard_arrow_down_outlined),
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: borderColor)),
      ),
      items: countryStateCity.stateList
          .map<DropdownMenuItem<StateByCountryModel>>(
            (StateByCountryModel c) => DropdownMenuItem(
              value: c,
              child: Text(c.name),
            ),
          )
          .toList(),
      onChanged: (val) {
        if (val == null) return;
        _loadCity(val);
        context
            .read<UpdateSellerProfileCubit>()
            .countryStateChange(val.id.toString());
        print('stateIdDrop: ${val.id.toString()}');
      },
    );
  }

  Widget _cityField() {
    final countryStateCity = context.read<CountryStateCityCubit>();
    return DropdownButtonFormField<CityByStateModel>(
      value: _cityByState,
      isDense: true,
      isExpanded: true,
      hint: const Text('City'),
      icon: const Icon(Icons.keyboard_arrow_down_outlined),
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: borderColor)),
      ),
      items: countryStateCity.cityList
          .map<DropdownMenuItem<CityByStateModel>>(
            (CityByStateModel c) => DropdownMenuItem(
              value: c,
              child: Text(c.name),
            ),
          )
          .toList(),
      onChanged: (val) {
        if (val == null) return;
        context.read<UpdateSellerProfileCubit>().cityChange(val.id.toString());
        print('cityIdDrop: ${val.id.toString()}');
      },
    );
  }
}
