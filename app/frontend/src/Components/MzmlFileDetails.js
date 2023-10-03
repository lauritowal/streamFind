import { useEffect, useState } from "react";
import axios from "axios";
import Modal from "@mui/material/Modal";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import Button from "@mui/material/Button";
import IconButton from "@mui/material/IconButton";
import CloseIcon from "@mui/icons-material/Close";
import Plot from "react-plotly.js";

function MzmlFileDetails({ selectedFileName, handleClose, msDataObj }) {
  const [analyses, setAnalyses] = useState([]);

  const style = {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: "translate(-50%, -50%)",
    width: 1500,
    height: 700,
    bgcolor: "white",
    border: "2px solid white",
    borderRadius: "25px",
    p: 5,
  };

  useEffect(() => {
    const requestData = {
      fileName: selectedFileName,
      msdata: msDataObj,
    };
    axios
      .post("http://127.0.0.1:8000/mzmldetails", requestData)
      .then((response) => {
        console.log("Getting Details!", response);
        const parsedAnalysesData = JSON.parse(response.data.analysesjson);
        setAnalyses(parsedAnalysesData);
      })
      .catch((error) => {
        console.error("Error sending files:", error);
      });
  }, [msDataObj, selectedFileName]);

  return (
    <div>
      <IconButton
        onClick={handleClose}
        aria-label="close"
        sx={{
          position: "absolute",
          right: 8,
          top: 8,
        }}
      >
        <CloseIcon />
      </IconButton>
      <Typography id="modal-modal-title" variant="h9" component="h2">
        {selectedFileName}
      </Typography>
      <Typography
        id="modal-modal-title"
        variant="h9"
        component="h2"
      ></Typography>
      <div style={{ display: "flex" }}>
        <p style={{ marginRight: "10px" }}>
          {analyses &&
            analyses.value &&
            analyses.value[0].attributes.names.value[0]}
          :
        </p>
        <p>
          {analyses && analyses.value && analyses.value[0].value[0].value[0]}
        </p>
      </div>
      <div style={{ display: "flex" }}>
        <p style={{ marginRight: "10px" }}>
          {analyses &&
            analyses.value &&
            analyses.value[0].attributes.names.value[1]}
          :
        </p>
        <p>
          {analyses && analyses.value && analyses.value[0].value[1].value[0]}
        </p>
      </div>
      <div style={{ display: "flex" }}>
        <p style={{ marginRight: "10px" }}>
          {analyses &&
            analyses.value &&
            analyses.value[0].attributes.names.value[2]}
          :
        </p>
        <p>
          {analyses && analyses.value && analyses.value[0].value[2].value[0]}
        </p>
      </div>
      <div style={{ display: "flex" }}>
        <p style={{ marginRight: "10px" }}>
          {analyses &&
            analyses.value &&
            analyses.value[0].attributes.names.value[4]}
          :
        </p>
        <p>
          {analyses && analyses.value && analyses.value[0].value[4].value[0]}
        </p>
      </div>
      <div style={{ display: "flex" }}>
        <p style={{ marginRight: "10px" }}>
          {analyses &&
            analyses.value &&
            analyses.value[0].attributes.names.value[5]}
          :
        </p>
        <p>
          {analyses && analyses.value && analyses.value[0].value[5].value[0]}
        </p>
      </div>
      <div style={{ display: "flex" }}>
        <p style={{ marginRight: "10px" }}>
          {analyses &&
            analyses.value &&
            analyses.value[0].attributes.names.value[7]}
          :
        </p>
        <p>
          {analyses && analyses.value && analyses.value[0].value[7].value[0]}
        </p>
      </div>
      <div style={{ display: "flex" }}>
        <p style={{ marginRight: "10px" }}>
          {analyses &&
            analyses.value &&
            analyses.value[0].attributes.names.value[8]}
          :
        </p>
        <p>
          {analyses && analyses.value && analyses.value[0].value[8].value[0]}
        </p>
      </div>
      <div style={{ display: "flex" }}>
        <p style={{ marginRight: "10px" }}>
          {analyses &&
            analyses.value &&
            analyses.value[0].attributes.names.value[9]}
          :
        </p>
        <p>
          {analyses && analyses.value && analyses.value[0].value[9].value[0]}
        </p>
      </div>
      <div style={{ display: "flex" }}>
        <p style={{ marginRight: "10px" }}>
          {analyses &&
            analyses.value &&
            analyses.value[0].attributes.names.value[15]}
          :
        </p>
        <p>
          {analyses &&
            analyses.value &&
            analyses.value[0].value[15].value[0].toString()}
        </p>
      </div>
      <div style={{ display: "flex" }}>
        <p style={{ marginRight: "10px" }}>
          {analyses &&
            analyses.value &&
            analyses.value[0].attributes.names.value[21]}
          :
        </p>
        <p>
          {analyses && analyses.value && analyses.value[0].value[21].value[0]}
        </p>
      </div>
      <div style={{ display: "flex" }}>
        <p style={{ marginRight: "10px" }}>
          {analyses &&
            analyses.value &&
            analyses.value[0].attributes.names.value[14]}
          :
        </p>
        <p>
          {analyses && analyses.value && analyses.value[0].value[14].value[0]}
        </p>
      </div>
      <div style={{ display: "flex" }}>
        <p style={{ marginRight: "10px" }}>
          {analyses &&
            analyses.value &&
            analyses.value[0].attributes.names.value[23]}
          :
        </p>
        <p>
          {analyses &&
            analyses.value &&
            analyses.value[0]?.value[23]?.value[0]?.value.length}
        </p>
      </div>
    </div>
  );
}

export default MzmlFileDetails;
