import React, { useState } from "react";
import axios from "axios";
import IconButton from "@mui/material/IconButton";
import CloseIcon from "@mui/icons-material/Close";
import Typography from "@mui/material/Typography";
import { FormControl } from "@mui/material";
import { Button, Input } from "@mui/material";

function ChangeParameters({ find_features, handleClose, group_features }) {
  const initialFormState = {
    ppm: 12,
    minpeakwidth: 5,
    maxpeakwidth: 40,
    snthresh: 20,
    minprefilter: 5,
    maxprefilter: 1500,
    mzCenterFun: "wMean",
    integrate: 1,
    mzdiff: 0.0005,
    fitgauss: true,
    noise: 500,
    verboseColumns: true,
    firstBaselineCheck: true,
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
      parameters: formState,
    };
    if (find_features !== undefined) {
      requestData.msData = find_features;
      requestData.data_type = "find_features";
    } else if (group_features !== undefined) {
      requestData.msData = group_features;
      requestData.data_type = "group_features";
    }
    try {
      const response = await axios.post(
        "http://127.0.0.1:8000/custom_find_features",
        requestData
      );
      console.log(requestData);
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
      <FormControl onSubmit={handleSubmit}>
        {Object.keys(initialFormState).map((paramName) => (
          <div key={paramName}>
            <label htmlFor={paramName}>{paramName}</label>
            <Input
              type="text"
              id={paramName}
              value={formState[paramName]}
              onChange={(e) => handleChange(paramName, e.target.value)}
            />
          </div>
        ))}
        <Button onClick={handleSubmit} type="submit">
          Submit
        </Button>
      </FormControl>
    </div>
  );
}

export default ChangeParameters;
