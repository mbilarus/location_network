import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:pinput/pinput.dart' as pin;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:loc_net/src/bloc.dart';
import 'package:loc_net/src/ui.dart';
import './box.dart';

GetIt locator = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  locator.registerSingleton<LocNetThemeData>(LocNetThemeData());
  await initStorage();
  runApp(const LocNet());
}

class LocNet extends StatelessWidget {
  const LocNet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: locator.get<LocNetThemeData>().baseTheme,
      debugShowCheckedModeBanner: false,
      title: 'LocNET',
      home: const AuthorizationPage(),
    );
  }
}

extension PinTheme on ThemeData {
  pin.PinTheme get defaultPinTheme => pin.PinTheme(
        width: 48,
        height: 48,
        textStyle: const TextStyle(
            fontSize: 18,
            color: Color.fromRGBO(30, 60, 87, 1),
            fontWeight: FontWeight.w600),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
          borderRadius: BorderRadius.circular(20),
        ),
      );

  pin.PinTheme get focusedPinTheme => defaultPinTheme.copyDecorationWith(
        border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
        borderRadius: BorderRadius.circular(8),
      );

  pin.PinTheme get submittedPinTheme => defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration?.copyWith(
          color: const Color.fromRGBO(234, 239, 243, 1),
        ),
      );
}

class LocNetThemeData {
  ThemeData get baseTheme => ThemeData(
        backgroundColor: const Color.fromRGBO(212, 214, 233, 1),
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 24,
            color: Color.fromRGBO(62, 71, 122, 1),
          ),
        ),
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            )),
            minimumSize: MaterialStateProperty.resolveWith<Size?>(
              (_) => const Size.fromHeight(48),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (_) => const Color.fromRGBO(78, 106, 255, 1),
            ),
          ),
        ),
      );
}

class AuthorizationPage extends StatelessWidget {
  const AuthorizationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: MultiProvider(
        providers: [
          Provider<VKAuthCubit>(
            create: (_) => VKAuthCubit(),
          ),
          Provider<PhoneAuthCubit>(
            create: (_) => PhoneAuthCubit(),
          )
        ],
        child: SingleChildScrollView(child:Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 0),
          child: Column(
            children: const [
              LocNetLogo(),
              SizedBox(
                height: 30,
              ),
              AuthorizationForm(),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class AuthorizationForm extends StatefulWidget {
  const AuthorizationForm({Key? key}) : super(key: key);

  @override
  State<AuthorizationForm> createState() => AuthorizationFormState();
}

class AuthorizationFormState extends State<AuthorizationForm>
    with TickerProviderStateMixin {
  AuthorizationFormState();
  String validationMessage = '';
  Color textFieldBoxColor = Colors.white;
  bool formIsDisabled = false;
  TabController? tabController;
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    return Column(
      children: [
        Text('Авторизация', style: Theme.of(context).textTheme.headline1),
        const SizedBox(
          height: 30,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(97, 132, 208, 1).withOpacity(0.6),
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            controller: tabController,
            tabs: <Widget>[
              const Tab(
                text: 'Через телефон',
                icon: Icon(Icons.phone),
              ),
              Tab(
                text: 'Через ВК',
                icon: SvgPicture.asset('assets/vk_logo.svg', height: 24),
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.maxFinite,
          height: 160,
          child: TabBarView(
            controller: tabController,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  runSpacing: 20.0,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    PhoneTextField(
                      textFieldBoxColor: textFieldBoxColor,
                      isDisabled: formIsDisabled,
                      controller: phoneController,
                      onChanged: (text) => box.put('authPhone', text),
                    ),
                    LocNetButton(
                      isDisabled: formIsDisabled,
                      text: 'Войти',
                      icon: const Icon(
                        Icons.key,
                        color: Colors.white,
                      ),
                      onPressed: () => _verify(context),
                    ),
                    Text(
                      validationMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  LocNetButton(
                    isDisabled: formIsDisabled,
                    text: 'Войти',
                    icon: SvgPicture.asset('assets/vk_logo.svg', height: 24),
                    style:
                        Theme.of(context).elevatedButtonTheme.style?.copyWith(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (_) => Colors.purpleAccent,
                              ),
                            ),
                    onPressed: () async {
                      await Provider.of<VKAuthCubit>(context, listen: false)
                          .authFromVK();
                    },
                  ),
                ]),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    tabController?.dispose();
    phoneController.dispose();
  }

  void _markError(String error) {
    setState(() {
      textFieldBoxColor = const Color.fromRGBO(255, 217, 217, 1);
      validationMessage = error;
      formIsDisabled = false;
    });
  }

  void _hideError({bool formIsDisabled = false}) {
    setState(() {
      textFieldBoxColor = Colors.white;
      validationMessage = '';
      formIsDisabled = formIsDisabled;
    });
  }

  void _verify(BuildContext context) async {
    final String phoneWithoutCode = phoneController.text;
    if (phoneWithoutCode.length == 10) {
      _hideError(formIsDisabled:true);
      PhoneAuthCubit phoneAuthCubit =
          Provider.of<PhoneAuthCubit>(context, listen: false);
      phoneAuthCubit.stream.listen((state) {
        if (state is PhoneAuthCubitVerifyFailed) {
          _markError('Ошибка сервиса аутентификации');
        }
        if (state is PhoneAuthCubitVerificationIdReceived) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return Provider.value(
                value: phoneAuthCubit,
                child: const VerificationScreen(),
              );
            }),
          );
        }
      });
      await phoneAuthCubit.verifyPhone(phoneWithoutCode: phoneWithoutCode);
    } else {
      setState(() {
        _markError('Необходимо ввести номер телефона');
        formIsDisabled = false;
      });
    }
  }
}

class LocNetButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final ButtonStyle? style;
  final void Function() onPressed;
  final bool isDisabled;

  const LocNetButton({
    Key? key,
    required this.text,
    required this.icon,
    this.style,
    required this.onPressed,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = style ?? Theme.of(context).elevatedButtonTheme.style;
    return ElevatedButton(
      style: buttonStyle?.copyWith(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (isDisabled) {
              return Colors.grey;
            } else {
              return const Color.fromRGBO(78, 106, 255, 1);
            }
          },
        ),
      ),
      onPressed: isDisabled ? () {} : onPressed,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.horizontal,
        spacing: 12.0,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          icon,
        ],
      ),
    );
  }
}

class LocNetLogo extends StatelessWidget {
  const LocNetLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size;
    return SvgPicture.asset('assets/logo.svg',
        height: screenHeight.height * 0.3);
  }
}

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    final phoneAuthCubit = Provider.of<PhoneAuthCubit>(context, listen: false);
    phoneAuthCubit.stream.listen((state) {
      if (state is PhoneAuthCubitAuthSuccess) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LocNetHomePage(),
            ),
            (route) => false);
      } else {
        print(state);
      }
    });
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 0),
        child: Wrap(
          runSpacing: 32.0,
          alignment: WrapAlignment.center,
          children: [
            const LocNetLogo(),
            Text(
              'SMS-код отправлен на номер\n+7${box.get('authPhone')}',
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                color: const Color.fromRGBO(97, 132, 208, 1).withOpacity(0.6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: pin.Pinput(
                    length: 6,
                    defaultPinTheme: Theme.of(context).defaultPinTheme,
                    focusedPinTheme: Theme.of(context).focusedPinTheme,
                    submittedPinTheme: Theme.of(context).submittedPinTheme,
                    pinputAutovalidateMode: pin.PinputAutovalidateMode.onSubmit,
                    androidSmsAutofillMethod:
                        pin.AndroidSmsAutofillMethod.smsUserConsentApi,
                    autofocus: true,
                    showCursor: true,
                    onCompleted: (smsCode) async {
                      if (phoneAuthCubit.state
                          is PhoneAuthCubitVerificationIdReceived) {
                        await phoneAuthCubit.authWithPhone(smsCode: smsCode);
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LocNetHomePage extends StatefulWidget {
  const LocNetHomePage({Key? key}) : super(key: key);

  @override
  State<LocNetHomePage> createState() => _LocNetHomePageState();
}

class _LocNetHomePageState extends State<LocNetHomePage> {
  String uid = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(uid)));
  }

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  }
}
