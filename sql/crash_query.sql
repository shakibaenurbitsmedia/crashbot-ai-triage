SELECT
  issue_id,

  CONCAT(
    ANY_VALUE(e.title),
    " @ ",
    ANY_VALUE(blame_frame.file)
  ) AS issue_title,

  ANY_VALUE(application.display_version) AS app_version,
  ANY_VALUE(application.build_version) AS build_version,

  ANY_VALUE(device.model) AS device_model,
  ANY_VALUE(operating_system.name) AS os_version,

  COUNT(1) AS event_count,

  STRING_AGG(
    CONCAT(
      IFNULL(f.symbol, "unknown"),
      " (",
      IFNULL(f.file, "unknown"),
      ":",
      CAST(IFNULL(f.line, 0) AS STRING),
      ")"
    ),
    "\n"
    ORDER BY f.line
    LIMIT 15
  ) AS sample_stack_trace

FROM `democrashbot.firebase_crashlytics.com_shakibaenur_democrashbot_ANDROID`

LEFT JOIN UNNEST(exceptions) AS e
LEFT JOIN UNNEST(e.frames) AS f

WHERE is_fatal = TRUE

GROUP BY issue_id
ORDER BY event_count DESC
LIMIT 20;
