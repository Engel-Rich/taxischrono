import 'package:flutter/material.dart';
import 'package:taxischrono/services/firebaseauthservice.dart';
import 'package:taxischrono/varibles/variables.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Mom compte"),
            accountEmail: const Text('email@gmail.com'),
            currentAccountPicture: CircleAvatar(
              radius: 70,
              child: ClipOval(
                child: Image.network(
                  'https://png.pngtree.com/png-clipart/20190924/original/pngtree-business-people-avatar-icon-user-profile-free-vector-png-image_4815126.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 90,
                ),
              ),
            ),
            // decoration: const BoxDecoration(
            //   color: Colors.blue,
            //   image: DecorationImage(
            //       fit: BoxFit.fill,
            //       image: NetworkImage(
            //           'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png')),
            // ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Mon compte'),
            // ignore: avoid_returning_null_for_void
            onTap: () => null,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Friends'),
            // ignore: avoid_returning_null_for_void
            onTap: () => null,
          ),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Mes Requetes'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Packages'),
            // ignore: avoid_returning_null_for_void
            onTap: () => null,
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Policies'),
            // ignore: avoid_returning_null_for_void
            onTap: () => null,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Partager l\'appli'),
            // ignore: avoid_returning_null_for_void
            onTap: () => null,
          ),
          ListTile(
            title: const Text('Deconexion'),
            leading: const Icon(Icons.exit_to_app),
            // ignore: avoid_returning_null_for_void
            onTap: () async => Authservices().logOut(),
          ),
        ],
      ),
    );
  }
}
