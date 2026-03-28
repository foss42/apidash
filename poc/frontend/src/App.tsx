import { lazy, Suspense } from "react";
import { Routes, Route } from "react-router-dom";
import Layout from "./components/Layout";
import HomePage from "./pages/HomePage";
import EvalPage from "./pages/EvalPage";
import ResultsPage from "./pages/ResultsPage";
import HistoryPage from "./pages/HistoryPage";

const BenchmarksPage = lazy(() => import("./pages/BenchmarksPage"));

export default function App() {
  return (
    <Layout>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/evaluate" element={<EvalPage />} />
        <Route path="/results/:jobId" element={<ResultsPage />} />
        <Route path="/history" element={<HistoryPage />} />
        <Route
          path="/benchmarks"
          element={
            <Suspense fallback={<div className="flex justify-center py-16"><span className="h-5 w-5 animate-spin rounded-full border-2 border-border border-t-primary" /></div>}>
              <BenchmarksPage />
            </Suspense>
          }
        />
      </Routes>
    </Layout>
  );
}
