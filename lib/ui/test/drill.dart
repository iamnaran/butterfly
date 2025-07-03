void main() {
  DrillSolution solution = DrillSolution(
    url: 'https://example.com',
    title: 'Example Title',
  );

  solution.run(); 
}

class DrillSolution {
  String url;
  String title;

  DrillSolution({
    required this.url,
    required this.title,
  });

  void run() {
    print('DrillSolution: $title at $url');
  }
}