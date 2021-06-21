import 'dart:io';
import 'dart:ui';

import 'package:blood_bank_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

final mainReference = FirebaseDatabase.instance.reference();

final Map<String, dynamic> _formData = {
  'firstname': null,
  'lastname': null,
  'email': null,
  'password': null,
  'gender': null,
  'dob': null,
  'weight': null,
  'blood': null,
  'address': null,
  'city': null,
  'mobileno': null,
  'aadhar': null
};

class Registration extends StatefulWidget {
  const Registration({Key key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool _enableFields = true;
  static final _formKey = GlobalKey<FormState>();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();

  final List _genderSel = ['Male', 'Female'];
  final List _bloodSel = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  void disableFields() {
    setState(() {
      if (_enableFields) {
        _enableFields = false;
      } else {
        _enableFields = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      top: false,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color(0xffff5f6d),
              ),
              backgroundColor: Color(0xffff5f6d),
              automaticallyImplyLeading: false,
              pinned: true,
              snap: true,
              floating: true,
              expandedHeight: 160.0,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffff5f6d), Color(0xffffc371)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  title: SizedBox(
                    height: 55,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Registration",
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  background: ClipPath(
                    clipper: DrawBox(),
                    child: Container(
                      height: size.height,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffff5f6d),
                            Color(0xffffc371),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: TextFormField(
                                    enabled: _enableFields,
                                    autofillHints: [AutofillHints.givenName],
                                    decoration: InputDecoration(
                                      labelText: 'First name',
                                    ),
                                    validator: (String value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a valid first name';
                                      }
                                      return null;
                                    },
                                    onSaved: (String value) {
                                      _formData['firstname'] = value;
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: TextFormField(
                                    enabled: _enableFields,
                                    autofillHints: [AutofillHints.familyName],
                                    decoration: InputDecoration(
                                      labelText: 'Last name',
                                    ),
                                    validator: (String value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a valid last name';
                                      }
                                      return null;
                                    },
                                    onSaved: (String value) {
                                      _formData['lastname'] = value;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: _enableFields,
                            autofillHints: [AutofillHints.email],
                            decoration: InputDecoration(
                              labelText: 'Email',
                            ),
                            validator: (String value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (String value) {
                              _formData['email'] = value;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: _enableFields,
                            autofillHints: [AutofillHints.newPassword],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _password,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Alphanumeric characters and symbols',
                            ),
                            validator: (String value) {
                              if (!value.contains(RegExp(r'^.{7,15}$'))) {
                                return "Password must be between 7-15 characters.";
                              }
                              if (!value.contains(RegExp(r'\d'))) {
                                return "Must contain at least one number.";
                              }
                              if (!value.contains(RegExp(r'[a-z]'))) {
                                return "Must contain a lowercase letter.";
                              }
                              if (!value.contains(RegExp(r'[A-Z]'))) {
                                return "Must contain an uppercase letter.";
                              }
                              if (!value.contains(RegExp(r'[#?!@$%^&*-]'))) {
                                return "Must contain a symbol";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            onSaved: (String value) {
                              _formData['password'] = value;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: _enableFields,
                            autofillHints: [AutofillHints.newPassword],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _confirmpassword,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Re-enter password',
                            ),
                            validator: (String value) {
                              if (value == null || value.isEmpty) {
                                return 'Please re-enter your password';
                              }
                              if (_password.text != _confirmpassword.text) {
                                return "Password does not match";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.visiblePassword,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                    child: genderSelect(),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    child: dateOfBirthSelector(),
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: TextFormField(
                                    enabled: _enableFields,
                                    decoration: InputDecoration(
                                      labelText: 'Weight',
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    validator: (String value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a valid weight';
                                      }
                                      return null;
                                    },
                                    onSaved: (String value) {
                                      _formData['weight'] = value;
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: bloodGroup(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: _enableFields,
                            autofillHints: [AutofillHints.fullStreetAddress],
                            decoration: InputDecoration(
                              labelText: 'Address',
                            ),
                            keyboardType: TextInputType.streetAddress,
                            validator: (String value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid address';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              _formData['address'] = value;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: _enableFields,
                            autofillHints: [AutofillHints.addressCity],
                            decoration: InputDecoration(
                              labelText: 'City',
                            ),
                            keyboardType: TextInputType.streetAddress,
                            validator: (String value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid city';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              _formData['city'] = value;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: _enableFields,
                            autofillHints: [AutofillHints.telephoneNumber],
                            decoration: InputDecoration(
                                labelText: 'Phone',
                                hintText: 'Enter number without +91'),
                            keyboardType: TextInputType.phone,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (String value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              _formData['mobileno'] = value;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: _enableFields,
                            decoration: InputDecoration(
                              labelText: 'Aadhar number',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(12),
                            ],
                            validator: (String value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid aadhar number';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              _formData['aadhar'] = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  );
                },
                childCount: 1,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.check,
            color: Colors.grey[100],
          ),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              try {
                disableFields();
                UserCredential userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: _formData['email'],
                        password: _formData['password']);
                mainReference
                    .child("users/${userCredential.user.uid}")
                    .set(_formData);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Registered successfully"),
                  ),
                );
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.pop(context);
                });
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("The password provided is too weak."),
                    ),
                  );
                } else if (e.code == 'email-already-in-use') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "The account already exists for that email. Try logging in or forgot password."),
                      action: SnackBarAction(
                        label: "Close",
                        textColor: Colors.orange,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                }
              } catch (e) {
                print(e);
              }
              disableFields();
              return true;
            }
          },
        ),
      ),
    );
  }

  Widget dateOfBirthSelector() {
    return FormBuilderDateTimePicker(
      name: 'date',
      initialDatePickerMode: DatePickerMode.year,
      inputType: InputType.date,
      decoration: InputDecoration(
        labelText: 'Date of birth',
      ),
      initialDate: DateTime.now(),
      onSaved: (value) {
        _formData['dob'] = value.toString().split(' ').first;
      },
      validator: (value) {
        if (value == null) {
          return 'Please enter a valid date of birth';
        }
        return null;
      },
    );
  }

  Widget genderSelect() {
    return FormBuilderDropdown(
      enabled: _enableFields,
      name: 'gender',
      decoration: InputDecoration(
        labelText: 'Gender',
      ),
      // initialValue: 'Male',
      allowClear: false,
      hint: Text('Select Gender'),
      validator: (value) {
        if (value == null) {
          return 'Please select your gender';
        }
        return null;
      },
      items: _genderSel
          .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text('$gender'),
              ))
          .toList(),
      onSaved: (value) {
        _formData['gender'] = value;
      },
    );
  }

  Widget bloodGroup() {
    return FormBuilderDropdown(
      enabled: _enableFields,
      name: 'blood',
      decoration: InputDecoration(
        labelText: 'Blood group',
      ),
      allowClear: false,
      hint: Text('Select group'),
      validator: (value) {
        if (value == null) {
          return 'Please select your blood type';
        }
        return null;
      },
      items: _bloodSel
          .map((blood) => DropdownMenuItem(
                value: blood,
                child: Text('$blood'),
              ))
          .toList(),
      onSaved: (value) {
        _formData['blood'] = value;
      },
    );
  }
}
