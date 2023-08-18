import React, { useState } from "react";
import axios from "axios";
import IconButton from "@mui/material/IconButton";
import CloseIcon from "@mui/icons-material/Close";
import Typography from "@mui/material/Typography";

function ChangeParameters({ find_features, handleClose }) {
  const initialFormState = {
    ppm: 12,
    peakwidth: [5, 40],
    snthresh: 20,
    prefilter: [5, 1500],
    mzCenterFun: "wMean",
    integrate: 1,
    mzdiff: 0.0005,
    fitgauss: true,
    noise: 500,
    verboseColumns: true,
    roiList: [],
    firstBaselineCheck: true,
    roiScales: [],
    extendLengthMSW: false,
    class: "CentWaveParam",
  };

  const [formState, setFormState] = useState(initialFormState);

  const handleChange = (paramName, value) => {
    setFormState((prevState) => ({
      ...prevState,
      [paramName]: value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const requestData = {
      msData: find_features,
      parameters: formState,
    };
    try {
      const response = await axios.post(
        "http://127.0.0.1:8000/custom_find_features",
        requestData
      );
      console.log("Response from server:", response.data);
      handleClose();
    } catch (error) {
      console.error("Error sending data:", error);
    }
  };

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
      <Typography variant="h6" component="h2">
        ChangeParameters
      </Typography>
      <form onSubmit={handleSubmit}>
        {Object.keys(initialFormState).map((paramName) => (
          <div key={paramName}>
            <label htmlFor={paramName}>{paramName}</label>
            <input
              type="text"
              id={paramName}
              value={formState[paramName]}
              onChange={(e) => handleChange(paramName, e.target.value)}
            />
          </div>
        ))}
        <button type="submit">Submit</button>
      </form>
    </div>
  );
}

export default ChangeParameters;
