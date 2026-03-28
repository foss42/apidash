import JobHistory from "../components/JobHistory";

export default function HistoryPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-xl font-bold text-foreground">Job History</h1>
        <p className="mt-1 text-sm text-muted-foreground">All evaluation runs, most recent first.</p>
      </div>
      <JobHistory />
    </div>
  );
}
