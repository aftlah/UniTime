import 'package:flutter/material.dart';
import 'package:unitime/utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Home',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Courses Card
            _buildCoursesCard(context),
            const SizedBox(height: 20),

            // Go To Premium Banner
            _buildPremiumBanner(),
            const SizedBox(height: 20),

            // Tasks Section
            _buildTasksSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Take a look to your\ncourses & track your\nprogress',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Go to courses',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
          Image.asset('assets/images/books.png', height: 100),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(Icons.workspace_premium, color: AppColors.yellow),
        title: Text('Go To Premium Now',
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle:
            Text('Support Us & get unlimited access\nto the premium features'),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }

  Widget _buildTasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tasks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: Text('See All')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(onPressed: () {}, child: Text('Yesterday')),
            ElevatedButton(
              onPressed: () {},
              child: Text('Today'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
            TextButton(onPressed: () {}, child: Text('Tomorrow')),
            TextButton(onPressed: () {}, child: Text('Next 7 days')),
          ],
        ),
        const SizedBox(height: 20),
        // Empty Task State
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Image.asset('assets/images/girl_at_desk.png', height: 100),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "You don't have any tasks!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text("Press + button to add new tasks"),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.black,
                child: IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
