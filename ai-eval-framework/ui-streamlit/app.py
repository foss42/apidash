import os
import time

import httpx
import pandas as pd
import streamlit as st

DATASET_SERVICE = os.environ.get("DATASET_SERVICE_URL", "http://localhost:8004")
EVAL_ENGINE = os.environ.get("EVAL_ENGINE_URL", "http://localhost:8001")

st.set_page_config(page_title="AI Eval Framework", page_icon="🔬", layout="wide")

st.title("AI Eval Framework — POC")
st.caption("Upload a dataset, run an evaluation experiment, and inspect results.")

tab_datasets, tab_experiment, tab_results = st.tabs(
    ["📂 Datasets", "🚀 Run Experiment", "📊 Results"]
)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _get(url: str, **kwargs):
    try:
        r = httpx.get(url, timeout=30.0, **kwargs)
        r.raise_for_status()
        return r.json()
    except Exception as e:
        st.error(f"Request failed: {e}")
        return None


def _post(url: str, **kwargs):
    try:
        r = httpx.post(url, timeout=60.0, **kwargs)
        r.raise_for_status()
        return r.json()
    except Exception as e:
        st.error(f"Request failed: {e}")
        return None


# ---------------------------------------------------------------------------
# Tab 1 — Datasets
# ---------------------------------------------------------------------------

with tab_datasets:
    st.subheader("Upload a Dataset")
    st.markdown(
        "Upload a **CSV** or **JSONL** file. "
        "Rows should contain at least an `input` column and optionally an `expected_output` column."
    )

    uploaded = st.file_uploader(
        "Choose a file", type=["csv", "jsonl", "ndjson"], key="dataset_upload"
    )
    if uploaded is not None:
        if st.button("Upload", key="btn_upload"):
            files = {"file": (uploaded.name, uploaded.getvalue(), "application/octet-stream")}
            result = _post(f"{DATASET_SERVICE}/datasets/upload", files=files)
            if result:
                st.success(f"Dataset **{result['name']}** uploaded — {result['row_count']} rows.")
                st.json(result)

    st.divider()
    st.subheader("Existing Datasets")
    if st.button("Refresh datasets", key="btn_refresh_ds"):
        st.session_state.pop("ds_list", None)

    ds_list = _get(f"{DATASET_SERVICE}/datasets")
    if ds_list:
        for ds in ds_list:
            with st.expander(f"**{ds['name']}**  —  {ds['row_count']} rows  ({ds['id'][:8]}…)"):
                st.json(ds)
                sample = _get(f"{DATASET_SERVICE}/datasets/{ds['id']}/sample", params={"n": 5})
                if sample:
                    st.dataframe(pd.DataFrame(sample), use_container_width=True)
    elif ds_list is not None:
        st.info("No datasets uploaded yet.")


# ---------------------------------------------------------------------------
# Tab 2 — Run Experiment
# ---------------------------------------------------------------------------

with tab_experiment:
    st.subheader("Create an Evaluation Experiment")

    datasets = _get(f"{DATASET_SERVICE}/datasets") or []
    adapters_resp = _get(f"{EVAL_ENGINE}/adapters") or []
    metrics_resp = _get(f"{EVAL_ENGINE}/metrics") or []

    if not datasets:
        st.warning("Upload a dataset first (go to the **Datasets** tab).")
    else:
        ds_options = {f"{d['name']}  ({d['id'][:8]}…)": d["id"] for d in datasets}
        selected_ds_label = st.selectbox("Dataset", list(ds_options.keys()))
        selected_ds_id = ds_options[selected_ds_label]

        adapter_names = [a["name"] for a in adapters_resp] if adapters_resp else ["mock"]
        selected_adapter = st.selectbox("Model Adapter", adapter_names)

        model_choices = []
        for a in adapters_resp:
            if a["name"] == selected_adapter:
                model_choices = a.get("models", [])
                break
        if not model_choices:
            model_choices = ["gpt-4", "gpt-3.5-turbo", "mock-model"]
        selected_model = st.selectbox("Model", model_choices)

        metric_names = [m["name"] for m in metrics_resp] if metrics_resp else ["exact_match"]
        selected_metrics = st.multiselect("Metrics", metric_names, default=metric_names[:1])

        exp_name = st.text_input("Experiment name", value="poc-run-1")

        if st.button("Run Experiment", type="primary"):
            payload = {
                "name": exp_name,
                "dataset_id": selected_ds_id,
                "adapter": selected_adapter,
                "model": selected_model,
                "metrics": selected_metrics,
                "parameters": {},
            }
            resp = _post(f"{EVAL_ENGINE}/experiments", json=payload)
            if resp:
                exp_id = resp["id"]
                st.session_state["last_experiment_id"] = exp_id
                st.info(f"Experiment **{exp_name}** started — `{exp_id[:8]}…`")

                progress_bar = st.progress(0.0, text="Running…")
                status_placeholder = st.empty()

                while True:
                    time.sleep(0.5)
                    status = _get(f"{EVAL_ENGINE}/experiments/{exp_id}")
                    if status is None:
                        break
                    pct = float(status.get("progress", 0))
                    progress_bar.progress(min(pct, 1.0), text=f"{status['status']}  ({pct:.0%})")
                    if status["status"] in ("completed", "failed", "cancelled"):
                        break

                if status and status["status"] == "completed":
                    st.success("Experiment completed!")
                    st.json(status.get("results"))
                elif status:
                    st.error(f"Experiment ended with status: **{status['status']}**")
                    if status.get("error"):
                        st.code(status["error"])


# ---------------------------------------------------------------------------
# Tab 3 — Results
# ---------------------------------------------------------------------------

with tab_results:
    st.subheader("Experiment Results")
    experiments = _get(f"{EVAL_ENGINE}/experiments") or []

    if not experiments:
        st.info("No experiments have been run yet.")
    else:
        exp_options = {
            f"{e['name']}  [{e['status']}]  ({e['id'][:8]}…)": e["id"]
            for e in experiments
        }
        selected_exp_label = st.selectbox("Select experiment", list(exp_options.keys()))
        selected_exp_id = exp_options[selected_exp_label]

        exp_detail = _get(f"{EVAL_ENGINE}/experiments/{selected_exp_id}")
        if exp_detail:
            col1, col2, col3, col4 = st.columns(4)
            col1.metric("Status", exp_detail["status"])
            col2.metric("Adapter", exp_detail["adapter"])
            col3.metric("Model", exp_detail["model"])
            col4.metric("Progress", f"{exp_detail.get('progress', 0):.0%}")

            if exp_detail.get("results"):
                res = exp_detail["results"]
                st.markdown("#### Aggregate Metrics")
                metric_cols = st.columns(max(len(res.get("aggregate_metrics", {})), 1))
                for i, (k, v) in enumerate(res.get("aggregate_metrics", {}).items()):
                    metric_cols[i % len(metric_cols)].metric(k, f"{v:.4f}")

                info_cols = st.columns(3)
                info_cols[0].metric("Total Tokens", res.get("total_tokens", "—"))
                info_cols[1].metric("Total Cost ($)", f"{res.get('total_cost', 0):.4f}")
                info_cols[2].metric("Latency (ms)", f"{res.get('total_latency_ms', 0):.0f}")

            full_results = _get(f"{EVAL_ENGINE}/experiments/{selected_exp_id}/results")
            if full_results and full_results.get("samples"):
                st.markdown("#### Per-Sample Results")
                samples_df = pd.json_normalize(full_results["samples"])
                st.dataframe(samples_df, use_container_width=True, height=400)

                csv_data = samples_df.to_csv(index=False)
                st.download_button(
                    "Download CSV",
                    csv_data,
                    file_name=f"results_{selected_exp_id[:8]}.csv",
                    mime="text/csv",
                )
