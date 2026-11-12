enum FeedType {
  newF('New', 'newstories'),
  bestF('Best', 'beststories'),
  showF('Show', 'showstories'),
  jobsF('Jobs', 'jobstories');
  
  final String label;
  final String endpoint;
  const FeedType(this.label, this.endpoint);
}
