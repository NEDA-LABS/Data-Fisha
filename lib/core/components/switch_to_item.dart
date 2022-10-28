import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smartstock/core/models/external_service.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';

_iconContainer(String? svg) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Builder(
        builder: (context) => Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).primaryColorDark),
          child: SvgPicture.asset(
            'assets/svg/$svg',
            width: 24,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );

_externalIconContainer(Icon icon) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Builder(
        builder: (context) => Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColorDark),
            child: SizedBox(
              width: 24,
              child: icon,
            )
            // SvgPicture.asset(
            //   'assets/svg/$svg',
            //   width: 24,
            //   fit: BoxFit.scaleDown,
            // ),
            ),
      ),
    );

_name(String name) => Container(
      padding: const EdgeInsets.all(5),
      width: 80,
      child: Text(
        name,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            overflow: TextOverflow.ellipsis),
      ),
    );

Widget _switchToItem(SubMenuModule menu) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      child: GestureDetector(
        onTap: () => navigateTo(menu.link),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_iconContainer(menu.svgName), _name(menu.name)],
        ),
      ),
    );

Widget Function(ExternalService service) _switchToExternalItem(
        String rootPath) =>
    (ExternalService service) => Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: GestureDetector(
            onTap: () => navigateTo('$rootPath${service.pageLink}'),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _externalIconContainer(service.icon),
                _name(service.name)
              ],
            ),
          ),
        );

switchToItems(List<SubMenuModule> menus) =>
    menus.map<Widget>(_switchToItem).toList();

switchToExternalService(List<ExternalService> services, String rootPath) =>
    services.map<Widget>(_switchToExternalItem(rootPath)).toList();
