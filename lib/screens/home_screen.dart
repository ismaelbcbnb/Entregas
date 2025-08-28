import 'package:flutter/material.dart';
import 'contagens_tab.dart';
import 'meses_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Color(0xFFF5F5F5),
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 16,
                  right: 16,
                  bottom: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 76,
                      height: 76,
                      child: Image.asset('assets/images/package.png'),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
              Container(
                color: const Color(0xFFA6193C),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: Colors.white,
                  tabs: const [
                    Tab(text: 'Entregas'),
                    Tab(text: 'Meses'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ContagensTab(), MesesTab()],
      ),
    );
  }
}
