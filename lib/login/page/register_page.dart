
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aqi/common/common.dart';
import 'package:flutter_aqi/localization/app_localizations.dart';
import 'package:flutter_aqi/login/entity/LoginData.dart';
import 'package:flutter_aqi/net/dio_utils.dart';
import 'package:flutter_aqi/net/http_api.dart';
import 'package:flutter_aqi/routers/fluro_navigator.dart';
import 'package:flutter_aqi/routers/routers.dart';
import 'package:flutter_aqi/utils/change_notifier_manage.dart';
import 'package:flutter_aqi/res/resources.dart';
import 'package:flutter_aqi/utils/toast.dart';
import 'package:flutter_aqi/utils/other_utils.dart';
import 'package:flutter_aqi/widgets/my_app_bar.dart';
import 'package:flutter_aqi/widgets/my_button.dart';
import 'package:flutter_aqi/widgets/my_scroll_view.dart';
import 'package:flutter_aqi/login/widgets/my_text_field.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:sprintf/sprintf.dart';

/// design/1注册登录/index.html#artboard11
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with ChangeNotifierMixin<RegisterPage> {
  //定义一个controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _vCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  bool _clickable = false;
  
  @override
  Map<ChangeNotifier, List<VoidCallback>> changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>>{
      _nameController: callbacks,
      _vCodeController: callbacks,
      _passwordController: callbacks,
      _nodeText1: null,
      _nodeText2: null,
      _nodeText3: null,
    };
  }
  
  void _verify() {
    final String name = _nameController.text;
    final String  vCode = _vCodeController.text;
    final String  password = _passwordController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (vCode.isEmpty || vCode.length < 6) {
      clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }
  
  void _register() {
    Map<String,dynamic> params = new Map();
    params['username'] =  _nameController.text;
    params['code'] = _vCodeController.text;
    params['password'] = _passwordController.text;
    DioUtils.instance.requestNetwork<LoginData>(Method.post, HttpApi.register,
      params: params,
      queryParameters: {},
      onSuccess: (data) {
        if(data != null && data.code == 200){
          SpUtil.putString(Constant.phone, _nameController.text);
          NavigatorUtils.pushReplace(context, Routes.home, clearStack: true);
        }else if(data != null && data.code != 200){
          showToast(data.msg);
        }else{
          showToast("注册失败");
        }
      },
      onError: (code, msg) {
        showToast("注册失败");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: AppLocalizations.of(context).register,
        ),
        body: MyScrollView(
          keyboardConfig: Utils.getKeyboardActionsConfig(context, <FocusNode>[_nodeText1, _nodeText2, _nodeText3]),
          crossAxisAlignment: CrossAxisAlignment.center,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody(),
        ),
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      Text(
        AppLocalizations.of(context).openYourAccount,
        style: TextStyles.textBold26,
      ),
      Gaps.vGap16,
      MyTextField(
        key: const Key('phone'),
        focusNode: _nodeText1,
        controller: _nameController,
        maxLength: 11,
        keyboardType: TextInputType.phone,
        hintText: AppLocalizations.of(context).inputPhoneHint,
      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('vcode'),
        focusNode: _nodeText2,
        controller: _vCodeController,
        keyboardType: TextInputType.number,
        getVCode: () async {
          if (_nameController.text.length == 11) {
            Toast.show(AppLocalizations.of(context).verificationButton);
            /// 一般可以在这里发送真正的请求，请求成功返回true
            DioUtils.instance.requestNetwork<LoginData>(Method.get, sprintf(HttpApi.sendcode, [_nameController.text]),
              params: '',
              queryParameters: {},
              onSuccess: (data) {
                if(data != null && data.code == 200){
                  showToast("发送成功");
                }
              },
              onError: (code, msg) {

              },
            );
            return true;
          } else {
            Toast.show(AppLocalizations.of(context).inputPhoneInvalid);
            return false;
          }
        },
        maxLength: 6,
        hintText: AppLocalizations.of(context).inputVerificationCodeHint,
      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('password'),
        keyName: 'password',
        focusNode: _nodeText3,
        isInputPwd: true,
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
        maxLength: 16,
        hintText: AppLocalizations.of(context).inputPasswordHint,
      ),
      Gaps.vGap24,
      MyButton(
        key: const Key('register'),
        onPressed: _clickable ? _register : null,
        text: AppLocalizations.of(context).register,
      )
    ];
  }
}