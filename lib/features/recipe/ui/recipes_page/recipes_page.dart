import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_task/features/recipe/cubits/models/ingredient.dart';
import 'package:tech_task/features/recipe/cubits/recipes_cubit.dart';
import 'package:tech_task/features/recipe/cubits/recipes_state.dart';
import 'package:tech_task/features/recipe/di/app_initializer.dart';
import 'package:tech_task/features/recipe/utils/state_status.dart';

class RecipesPage extends StatefulWidget {
  final List<Ingredient> ingredients;

  const RecipesPage({super.key, required this.ingredients});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  late RecipesCubit _recipesCubit;

  @override
  void initState() {
    _recipesCubit = AppInitializer.getIt<RecipesCubit>();
    final ingredientNames = widget.ingredients.map((e) => e.title).toList();
    _recipesCubit.getRecipes(ingredientNames);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesCubit, RecipesState>(
      bloc: _recipesCubit,
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text('Recipes'),
        ),
        body: SafeArea(child: _buildRecipesBody(state)),
      ),
    );
  }

  Widget _buildRecipesBody(RecipesState state) {
    if (state.getRecipesStateStatus == StateStatus.loadingState) {
      return Center(child: CircularProgressIndicator());
    }

    if (state.getRecipesStateStatus == StateStatus.failedState) {
      return Text('Oops! Something went wrong');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.recipes.length,
                itemBuilder: (context, index) {
                  final recipe = state.recipes[index];

                  return SizedBox(
                    height: 150,
                    child: RecipeItem(
                        title: recipe.title, ingredients: recipe.ingredients),
                  );
                }),
          )
        ],
      ),
    );
  }
}

class RecipeItem extends StatelessWidget {
  final String title;
  final List<String> ingredients;

  const RecipeItem({super.key, required this.title, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        Expanded(
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                return Text(
                  ingredients[index],
                  textAlign: TextAlign.start,
                );
              }),
        )
      ],
    );
  }
}
