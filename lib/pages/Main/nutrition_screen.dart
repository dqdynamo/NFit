import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'meal_reminder_screen.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double consumedCalories = 1250;
    final double dailyGoal = 2000;
    final double remaining = dailyGoal - consumedCalories;

    final macros = {
      'Protein': [60, 100, Colors.green],
      'Carbs': [180, 300, Colors.orange],
      'Fat': [50, 70, Colors.redAccent],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MealReminderScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 100,
              lineWidth: 14,
              percent: (consumedCalories / dailyGoal).clamp(0.0, 1.0),
              progressColor: Colors.deepOrange,
              backgroundColor: Colors.deepOrange.shade100,
              circularStrokeCap: CircularStrokeCap.round,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Calories', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    '${consumedCalories.toInt()}/${dailyGoal.toInt()} kcal',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${remaining.toInt()} kcal left',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _MealCard(
              icon: Icons.breakfast_dining,
              title: 'Breakfast',
              calories: 300,
              items: ['Oats', 'Banana', 'Almonds'],
            ),
            _MealCard(
              icon: Icons.lunch_dining,
              title: 'Lunch',
              calories: 600,
              items: ['Rice', 'Chicken', 'Salad'],
            ),
            _MealCard(
              icon: Icons.dinner_dining,
              title: 'Dinner',
              calories: 350,
              items: ['Soup', 'Bread'],
            ),
            _MealCard(
              icon: Icons.emoji_food_beverage,
              title: 'Snacks',
              calories: 100,
              items: ['Yogurt'],
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: macros.entries.map((e) {
                final name = e.key;
                final value = e.value[0] as int;
                final goal = e.value[1] as int;
                final color = e.value[2] as Color;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$name: $value g / $goal g'),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: (value / goal).clamp(0.0, 1.0),
                        backgroundColor: color.withOpacity(0.2),
                        color: color,
                        minHeight: 10,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Food'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int calories;
  final List<String> items;

  const _MealCard({
    required this.icon,
    required this.title,
    required this.calories,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepOrange, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(items.join(', ')),
        trailing: Text('$calories kcal', style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }
}
